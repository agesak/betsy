require "test_helper"

describe CartitemsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  # need to dry up code using fixture data
  describe "create" do
    it "can create a cart item" do
      perform_login

      user = User.first
      category = Category.create(name: "Sweatpants")
      product = Product.create(
          name: "Yellow Socks",
          inventory: 10,
          cost: 10.00,
          description: "best socks in the wooooorld",
          image: "image",
          category_ids: category.id
          )

      cart = Cart.find_by(id: session[:cart_id])

      expect{
        post product_cartitems_path(product.id)
      }.must_differ "cart.cartitems.count", 1

      must_respond_with :redirect
    end

    it "cart item quantity will not increase if there is not enough inventory" do
      perform_login

      user = User.first
      category = Category.create(name: "Sweatpants")
      product = Product.create(
          name: "Yellow Socks",
          inventory: 1,
          cost: 10.00,
          description: "best socks in the wooooorld",
          image: "image",
          category_ids: category.id
      )

      cart = Cart.find_by(id: session[:cart_id])

      # added the product to the cart
      post product_cartitems_path(product.id)

      cart_item = cart.cartitems.find_by(product: product)

      # adding the same product again
      expect{
        post product_cartitems_path(product.id)
      }.wont_change "cart_item.qty"

      expect(flash[:error]).wont_be_nil
      must_respond_with :redirect
    end

  end


  describe "destroy" do
    it "can destroy a cart item" do
      # creates a user
      perform_login

      user = User.first
      category = Category.create(name: "Sweatpants")
      product = Product.new(
          name: "Yellow Socks",
          inventory: 10,
          cost: 10.00,
          description: "best socks in the wooooorld",
          image: "image",
          category_ids: category.id
      )

      cart = Cart.find_by(id: session[:cart_id])

      cart_item = Cartitem.create(
          cart: cart,
          product: product,
          qty: 3,
          cost: product.cost
      )

      expect{
        delete cartitem_path(cart_item.id)
      }.must_change "cart.cartitems.count", -1

      must_respond_with :redirect
      must_redirect_to cart_path
    end


  end
end
