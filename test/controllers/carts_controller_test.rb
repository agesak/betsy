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
            cc_number: "1234 5678 9123 4567",
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

      expect(current_cart).wont_be_nil
      expect(session[:cart_id]).must_equal current_cart.id

    end

    it "should have the same cart throughout the site " do

      get root_path
      cart_id = session[:cart_id]
      cart = Cart.find_by(id: cart_id)

      expect{
        perform_login
       }.wont_change "Cart.count"

      current_cart_id = session[:cart_id]
      current_cart = Cart.find_by(id: current_cart_id)

      expect(current_cart).wont_be_nil
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

    it "can purchase a cart for a guest" do
      get root_path
      # why doesnt this work
      puts session[:cart_id]
      cart = session[:cart_id]
      patch cart_path(cart), params: paid_cart_hash

      new_cart = Cart.find(cart)
      # puts session[:cart_id]
      # why is this still pending?
      puts new_cart.status
      # skip
      # updates cart status
      # check flash message
      # make sure cart empties
      # make sure redirects correctly
    end

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
      skip
    end
  end

end
