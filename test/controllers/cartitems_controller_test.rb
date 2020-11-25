require "test_helper"

describe CartitemsController do

  describe "add_qty" do
    it "can increase the quantity of the cart item by 1" do

      # start a new cart
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      cart_item = Cartitem.create(
          cart: cart,
          product: products(:product0),
          qty: 3,
          cost: products(:product0).cost
      )

      post add_path(cart_item.id)
      updated_cart_item = Cartitem.find_by(id: cart_item.id)

      expect(updated_cart_item.qty).must_equal 4
      expect(updated_cart_item.qty > cart_item.qty).must_equal true
      must_redirect_to cart_path
    end

    it "will not increase if there is not enough inventory" do

      # start a new cart
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      # add the product to the cart, product only has one in inventory
      post add_to_cart_path(products(:product1).id)
      cart_item = cart.cartitems.find_by(product: products(:product1))

      post add_path(cart_item.id)
      expect(flash[:error]).must_equal "Sorry, not enough inventory"

      updated_cart_item = Cartitem.find_by(id: cart_item.id)

      expect(updated_cart_item.cart).must_equal cart_item.cart
      expect(updated_cart_item.id).must_equal cart_item.id
      expect(updated_cart_item.product).must_equal cart_item.product
      expect(updated_cart_item.qty).must_equal 1
      expect(updated_cart_item.qty).must_equal cart_item.qty
      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end

  describe "reduce_qty" do
    it "can reduce the quantity of the cart item by 1" do

      # start a new cart
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      cart_item = Cartitem.create(
          cart: cart,
          product: products(:product0),
          qty: 3,
          cost: products(:product0).cost
      )

      post reduce_path(cart_item.id)
      updated_cart_item = Cartitem.find_by(id: cart_item.id)

      expect(updated_cart_item.cart).must_equal cart_item.cart
      expect(updated_cart_item.id).must_equal cart_item.id
      expect(updated_cart_item.product).must_equal cart_item.product
      expect(updated_cart_item.qty).must_equal 2
      expect(updated_cart_item.qty < cart_item.qty).must_equal true
      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end


  describe "destroy" do
    it "can destroy a cart item" do
      perform_login
      cart = Cart.find_by(id: session[:cart_id])
      # add a new cart item to cart
      post add_to_cart_path(products(:product0).id)

      # find the cart item from the cart
      cart_item = cart.cartitems.find_by(product: products(:product0))

      expect{
        delete cartitem_path(cart_item.id)
      }.must_change "cart.cartitems.count", -1

      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end

  describe "update status" do
    it "can update the status" do
      perform_login
      cart = Cart.find_by(id: session[:cart_id])
      post add_to_cart_path(products(:product0).id)
      expect(cart.cartitems.length).must_equal 1

    end

  end
end
