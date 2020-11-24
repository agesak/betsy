require "test_helper"

describe CartsController do

  before do
    @cart = carts(:cart0)
  end

  let(:paid_cart_hash){
    {
        cart: {
            email: "ada@adadev.org",
            mailing_address: "315 5th Ave S Suite 200, Seattle, WA 98104",
            name: "ada",
            cc_number: "1234567891234567",
            cc_expiration: "12/2021",
            cc_cvv: "111",
            zip: "98104"},
    }
  }

  describe 'current cart' do
    it "creates a new cart when visiting the site for the first time" do

      expect{
        get root_path
      }.must_differ "Cart.count", 1

      cart_id = session[:cart_id]
      current_cart = Cart.find_by(id: cart_id)

      expect(cart_id).wont_be_nil
      expect(session[:cart_id]).must_equal current_cart.id

    end

    it "should have the same cart throughout the site as a guest " do

      get root_path
      cart_id = session[:cart_id]
      cart = Cart.find_by(id: cart_id)

      expect{
        get product_path(products(:product0))
      }.wont_change "Cart.count"

      expect{
        get product_path(products(:product1))
      }.wont_change "Cart.count"

      expect{
        get cart_path(session[:cart_id])
      }.wont_change "Cart.count"

      current_cart_id = session[:cart_id]
      current_cart = Cart.find_by(id: current_cart_id)

      expect(current_cart_id).wont_be_nil
      expect(current_cart.id).must_equal cart.id

    end

    it "should have the same cart throughout the site when logged in " do

      get root_path
      cart_id = session[:cart_id]
      cart = Cart.find_by(id: cart_id)

      # login with a user
      expect{
        perform_login
       }.wont_change "Cart.count"

      expect{
        get product_path(products(:product0))
      }.wont_change "Cart.count"

      expect{
        get product_path(products(:product1))
      }.wont_change "Cart.count"

      expect{
        get cart_path(session[:cart_id])
      }.wont_change "Cart.count"

      current_cart_id = session[:cart_id]
      current_cart = Cart.find_by(id: current_cart_id)

      expect(current_cart_id).wont_be_nil
      expect(current_cart.id).must_equal cart.id

    end
  end

  describe "show" do

    it "will get show for current cart" do
      # Arrange
      get root_path
      cart_id = session[:cart_id]

      # Act
      get cart_path(cart_id)

      # Assert
      must_respond_with :success

    end

  end

  describe "purchase" do

    describe "logged in customer" do
      it "can purchase a cart for a logged in user" do
        perform_login

        cart = session[:cart_id]

        patch cart_path(cart), params: paid_cart_hash

        new_cart = Cart.find(cart)

        expect(flash[:success]).must_equal "Your order has been placed!"
        expect(new_cart.status).must_equal "paid"
        must_redirect_to view_confirmation_path(new_cart.id)
        expect(Cart.find(session[:cart_id]).cartitems.length).must_equal 0

      end

      it "redirects when there's an issue with placing the order" do
        perform_login
        paid_cart_hash[:cart][:email] = nil

        cart = session[:cart_id]

        patch cart_path(cart), params: paid_cart_hash

        new_cart = Cart.find(cart)

        expect(flash[:error]).must_equal "There was an error in placing your order"
        expect(new_cart.status).must_equal "pending"
        must_respond_with :bad_request
      end


    end

    describe "guest customer" do
      it "can purchase a cart for a guest" do
        get root_path
        cart = session[:cart_id]

        patch cart_path(cart), params: paid_cart_hash

        new_cart = Cart.find(cart)

        expect(flash[:success]).must_equal "Your order has been placed!"
        expect(new_cart.status).must_equal "paid"
        must_redirect_to view_confirmation_path(new_cart.id)
        expect(Cart.find(session[:cart_id]).cartitems.length).must_equal 0
      end

      it "redirects when there's an issue with placing the order" do
        get root_path

        paid_cart_hash[:cart][:email] = nil

        cart = session[:cart_id]

        patch cart_path(cart), params: paid_cart_hash

        new_cart = Cart.find(cart)

        expect(flash[:error]).must_equal "There was an error in placing your order"
        expect(new_cart.status).must_equal "pending"
        must_respond_with :bad_request
      end
    end
  end
end
