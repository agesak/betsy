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


end
