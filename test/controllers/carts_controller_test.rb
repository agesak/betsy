require "test_helper"

describe CartsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

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
      current_cart = Cart.find_by(id: cart_id)

      # Act
      get cart_path(cart_id)

      # Assert
      must_respond_with :success

    end

  end

  describe "add to cart" do
    it "can add a new cart item" do
      # start a new cart
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      expect{
        post add_to_cart_path(products(:product0).id)
      }.must_differ "cart.cartitems.count", 1

      cart_item = Cartitem.find_by(product_id: products(:product0).id)

      expect(cart_item.cart).must_equal cart
      expect(cart_item.product).must_equal products(:product0)
      expect(cart_item.qty).must_equal 1
      expect(cart_item.cost).must_equal products(:product0).cost
      expect(flash[:success]).must_equal "Successfully added to cart"
      must_respond_with :redirect
      must_redirect_to product_path(products(:product0))
    end

    it "will not add to the cart if there is not enough inventory" do
      # start a new cart
      skip
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      # add the product to the cart, product only has one in inventory
      post product_cartitems_path(products(:product1).id)

      cart_item = cart.cartitems.find_by(product: products(:product1))

      # add the same product again
      expect{
        post product_cartitems_path(products(:product1).id)
      }.wont_change "cart_item.qty"

      expect(flash[:error]).wont_be_nil
      must_respond_with :redirect

    end

  end

end
