require "test_helper"

describe Cartitem do
  before do
    @cartitem = cartitems(:cartitem0)
    @cart = carts(:cart0)
    @product = products(:product0)
  end

  describe "instantiation" do

    it "can be instantiated" do
      expect(@cartitem.valid?).must_equal true
    end

    it "has the required fields" do
      [:qty, :cost, :cart, :product].each do |field|
        expect(@cartitem).must_respond_to field
      end
    end
  end

  describe "relations" do

    it "belongs to a cart" do
      expect(@cartitem.cart).must_equal @cart
    end

    it "belongs to a product" do
      expect(@cartitem.product).must_equal @product
    end
  end

  describe "cartitem subtotal" do

    it "can calculate the subtotal for the cartitem" do

      item1 = cartitems(:cartitem0)
      item2 = cartitems(:cartitem1)

      expect(item1.cartitem_subtotal).must_equal 400.00
      expect(item2.cartitem_subtotal).must_equal 404.00
    end
  end
end
