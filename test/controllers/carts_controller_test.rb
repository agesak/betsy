require "test_helper"

describe CartsController do

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

    it "can purchase a cart for a logged in user" do
      skip
      # updates cart status
      # check flash message
      # make sure cart empties
      # make sure redirects correctly
    end

    it "can purchase a cart for a guest user" do
      skip
      # updates cart status
      # check flash message
      # make sure cart empties
      # make sure redirects correctly
    end
  end

end
