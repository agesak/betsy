require "test_helper"

describe CartitemsController do

  before do
    @product = products(:product0)
    @one_inventory_product = products(:product1)
    @user = users(:ada)
    @cartitem = cartitems(:cartitem0)
  end

  let(:cartitem_hash){
    {
    product: {
      name: "Yellow Socks",
      inventory: 10,
      cost: 10.00,
      description: "best socks in the wooooorld",
      image: "image",
      category_ids: Category.create(name: "Sweatpants").id,
      user: @user
      }
    }
  }

  describe "create" do
    it "can create a cart item for a logged in user" do
      perform_login

      expect{
        post product_cartitems_path(@product.id), params: cartitem_hash
      }.must_differ "Cartitem.count", 1

      must_respond_with :redirect
    end

    it "can create a cart item for a guest " do
      expect{
        post product_cartitems_path(@product.id), params: cartitem_hash
      }.must_differ "Cartitem.count", 1

      must_respond_with :redirect
    end

    it "wont add to cart if not enough inventory" do
      perform_login

      cart = Cart.find_by(id: session[:cart_id])
      expect(cart.cartitems.length).must_equal 0

      expect {
      post product_cartitems_path(@one_inventory_product.id)}.must_differ "Cartitem.count", 1
      expect {
        post product_cartitems_path(@one_inventory_product.id)}.wont_change "Cartitem.count"

      expect(flash[:error]).wont_be_nil
      must_respond_with :redirect
    end

  end

  describe "reduce_qty" do
    it "can reduce the quantity of the cart item by 1" do
      perform_login
      expect{
        post reduce_path(@cartitem.id).must_differ "@cartitem.qty", -1
      }
    end
  end


  describe "destroy" do
    it "can destroy a cart item" do
      perform_login

      expect{
        delete cartitem_path(@cartitem.id)
      }.must_change "Cartitem.count", -1
      
      must_respond_with :redirect
      must_redirect_to cart_path
    end


  end
end
