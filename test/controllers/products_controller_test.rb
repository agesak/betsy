require "test_helper"

describe ProductsController do

  describe "Authentication - Logged in Users" do

    before do
      @user = perform_login(users(:ada))
    end

    it "logged in users can access the new product page" do
      get new_product_path
      must_respond_with :success
    end

    it "logged in users can create a new product with all required attributes accurately, and redirect" do

      product_hash = {
          product: {
              name: "dumbbells",
              user: @user,
              cost: 15,
              inventory: 100,
              description: "5 lbs, set of 2",
              image: "https://placekitten.com/300/200",
              category_ids: [categories(:category_weights).id]
            }
          }

      expect{
        post products_path, params: product_hash
      }.must_change "Product.count", 1

      new_product = Product.find_by(name: product_hash[:product][:name])

      expect(new_product.name).must_equal "dumbbells"
      expect(new_product.user).must_equal users(:ada)
      expect(new_product.cost).must_equal 15
      expect(new_product.inventory).must_equal 100
      expect(new_product.description).must_equal "5 lbs, set of 2"
      expect(new_product.image).must_equal "https://placekitten.com/300/200"
      expect(new_product.category_ids).must_equal [categories(:category_weights).id]

      must_respond_with :found
      must_redirect_to product_path(new_product.id)
    end

    it "logged in users can't create new product if required fields are missing" do
      bad_product_hash = {
          product: {
              name: "bench"
          }
      }

      expect{
        post products_path, params: bad_product_hash
      }.wont_change "Product.count"

      bad_product = Product.find_by(name: bad_product_hash[:product][:name])
      expect(bad_product).must_be_nil
      must_respond_with :bad_request
    end

  end

  describe "Authentication - Guest Users" do

    before do
      delete logout_path, params: {} # log out
    end

    it "guest users (not logged in) can view the product index page" do
      get products_path
      must_respond_with :success
    end

    it "guest users can browse products by category" do
      get category_products_path(categories(:category_weights).id)
      must_respond_with :success
    end

    it "guest users can browse products by merchant" do
      get user_products_path(users(:ada).id)
      must_respond_with :success
    end

    it "guest users can access show product page" do
      get product_path(products(:product0).id)

      must_respond_with :success

      expect(products(:product0).name).must_equal "product0"
      expect(products(:product0).inventory).must_equal 10
    end

    it "will not show product with invalid ID" do
      get product_path(-1)
      must_respond_with :not_found
    end

    it "guest users can add products to cart" do
      post add_to_cart_path(products(:product1).id)

      must_respond_with :found
      must_redirect_to product_path(products(:product1).id)
    end

    it "guest users can't add product to cart if not enough inventory" do

      post add_to_cart_path(products(:product3).id) # inventory: 2
      post add_to_cart_path(products(:product3).id)
      post add_to_cart_path(products(:product3).id)

      must_respond_with :redirect
      must_redirect_to product_path(products(:product3).id)
    end

    it "guest users (not logged in) can't access the new product page" do
      get new_product_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "guest users (not logged in) can't access the edit product page" do
      get new_product_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "guest users (not logged in) can't delete products" do
      delete product_path(products(:product0).id)

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "guest users (not logged in) can't update products" do
      delete logout_path, params: {} # log out

      patch product_path(products(:product1).id), params: { product: { name: "jeggings" } }

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "guest users (not logged in) can't create a new product" do

      product_hash = {
          product: {
              name: "dumbbells",
              cost: 15,
              inventory: 100,
              description: "5 lbs, set of 2",
              image: "https://placekitten.com/300/200",
              category_ids: [categories(:category_weights).id]
          }
      }

      expect{
        post products_path, params: product_hash
      }.wont_change "Product.count"

      must_respond_with :redirect
      must_redirect_to root_path

    end

  end

  describe "Authorization" do

    before do
      user = perform_login(users(:ada))
    end

    it "Authorized merchants can access edit page for their own products" do
      get edit_product_path(products(:product1).id)

      must_respond_with :success
    end

    it "Should not render edit page for invalid product ID" do
      get edit_product_path(-1)
      must_respond_with :not_found
    end

    it "Authorized merchants can update their own products" do
      update_hash = {
          product: {
              name: "hoodie",
              cost: 15,
              inventory: 1,
              description: "comfy!",
              image: "https://placekitten.com/300/200",
              category_ids: [categories(:category_clothing).id]
          }
      }

      patch product_path(products(:product1).id),  params: update_hash

      updated_product = Product.find_by(name: "hoodie")
      expect(updated_product.name).must_equal "hoodie"
      expect(updated_product.inventory).must_equal 1
      expect(updated_product).must_equal products(:product1)

      must_respond_with :found
      must_redirect_to product_path(products(:product1).id)
    end

    it "will not update product with invalid params" do
      patch product_path(products(:product1).id), params: { product: { name: "" } }

      must_respond_with :bad_request
    end

    it "Authorized merchants can delete their own products" do

      expect{
        delete product_path(products(:product1).id)
      }.must_change "Product.count", -1

      deleted_product = Product.find_by(name: "product1")

      expect(deleted_product).must_be_nil
      must_respond_with :redirect
      must_redirect_to products_path

    end

    it "merchants can't access edit page for products they don't own" do

      get edit_product_path(products(:product3).id) # valentine's product

      must_respond_with :redirect
      must_redirect_to root_path

    end

    it "merchants can't delete products they don't own" do
      val_product_count = users(:valentine).products.count

      # ada tries to delete valentine's product

      expect{
        delete product_path(products(:product3).id)
      }.wont_change val_product_count

      must_respond_with :redirect
      must_redirect_to root_path
    end

  end



  # it "should destroy product" do
  #   product_to_delete = Product.create(
  #       name: "socks",
  #       user: users(:ada),
  #       cost: 19,
  #       inventory: 20,
  #       description: "made of wool",
  #       image: "https://placekitten.com/300/200",
  #       category_ids: [categories(:category_clothing)]
  #
  #   id = product_to_delete.id
  #
  #   expect{
  #     delete product_path(id)
  #   }.must_change "Product.count", -1
  #
  #   deleted_product = Product.find_by(name: "socks")
  #
  #   expect(deleted_product).must_be_nil
  #   must_respond_with :redirect
  #   must_redirect_to products_path
  #
  # end

  describe "Adding products to cart" do
    it "can add a new cart item" do
      # start a new cart
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      expect{
        post add_to_cart_path(products(:product0).id)
      }.must_differ "cart.cartitems.count", 1

      # cart_item = Cartitem.find_by(product_id: products(:product0).id)
      cart_item = cart.cartitems.find_by(product_id: products(:product0).id)

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
      get root_path
      cart = Cart.find_by(id: session[:cart_id])

      # add the product to the cart, product only has one in inventory
      post add_to_cart_path(products(:product1).id)

      cart_item = cart.cartitems.find_by(product: products(:product1))

      # add the same product again
      post add_to_cart_path(products(:product1).id)

      updated_cart_item = cart.cartitems.find_by(product: products(:product1))

      expect(cart_item.qty).must_equal updated_cart_item.qty
      expect(flash[:error]).must_equal "Sorry, not enough inventory"
      must_respond_with :redirect
      must_redirect_to product_path(products(:product1))

    end
  end
end
