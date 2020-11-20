require "test_helper"

describe ProductsController do

  before do
    @cat1 = Category.create(name: "clothing")
    @cat2 = Category.create(name: "equipment")
    @cat3 = Category.create(name: "food")

    @user = users(:ada)
  end



  let(:product) { Product.create(
                        name: "leggings",
                        user: @user,
                        cost: 44,
                        inventory: 20,
                        description: "they're like thick tights",
                        image: "https://placekitten.com/300/200",
                        category_ids: [@cat1.id, @cat2.id])
                      }

  it "should get index" do
    get products_path
    must_respond_with :success
  end

  it "should get new" do
    skip
    get new_product_path
    must_respond_with :success
  end

  it "should create a new product with all required attributes accurately, and redirect" do
    skip
    product_hash = {
      product: {
        name: "weights",
        user: @user,
        cost: 15,
        inventory: 100,
        description: "5 lbs, set of 2",
        image: "https://placekitten.com/300/200",
        category_ids: [@cat2.id]
      }
    }

    expect{
      post products_path, params: product_hash
    }.must_change "Product.count", 1

    new_product = Product.find_by(name: product_hash[:product][:name])

    expect(new_product.name).must_equal "weights"
    expect(new_product.user).must_equal @user
    expect(new_product.cost).must_equal 15
    expect(new_product.inventory).must_equal 100
    expect(new_product.description).must_equal "5 lbs, set of 2"
    expect(new_product.image).must_equal "https://placekitten.com/300/200"
    expect(new_product.category_ids).must_equal [@cat2.id]

    must_redirect_to product_path(new_product.id)
  end

  it "will not create product if required fields are missing" do
    skip
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
    must_respond_with :not_found
  end

  it "should show product" do
    get product_path(product.id)
    must_respond_with :success

    expect(product.name).must_equal "leggings"
    expect(product.category_ids).must_include @cat1.id
  end

  it "will not show product with invalid ID" do
    get product_path(-1)
    must_respond_with :not_found
  end

  it "should get edit" do
    skip
    get edit_product_path(product.id)
    must_respond_with :success
  end

  it "should not render edit page for invalid product ID" do
    get edit_product_path(-1)
    must_respond_with :not_found
  end

  # it "should update product" do
  #   skip
  #   patch product_path(product), params: { product: { name: "jeggings" } }
  #   must_redirect_to product_path(product)
  # end

  it "will not update product with invalid params" do
    skip
    patch product_path(product), params: { product: { name: "" } }
    must_respond_with :not_found
  end

  it "should destroy product" do
    skip
    product_to_delete = Product.create(
        name: "socks",
        user: @user,
        cost: 19,
        inventory: 20,
        description: "made of wool",
        image: "https://placekitten.com/300/200",
        category_ids: [@cat1.id, @cat2.id])

    id = product_to_delete.id

    expect{
      delete product_path(id)
    }.must_change "Product.count", -1

    deleted_product = Product.find_by(name: "socks")

    expect(deleted_product).must_be_nil
    must_respond_with :redirect
    must_redirect_to products_path

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
