require "test_helper"

describe Order do

  before do
    @cart = Cart.create!
    # TODO: these should be pulled from a fixture and not hard-coded
    @category = Category.create!(name: "conditioning")
    @product = Product.create!(name: "dumbbells", inventory: 7,
                               cost: 35, description: "why are these so hard to get in these covid times",
                               image: "image", category_ids: @category.id)
    @cartitem = Cartitem.create!(qty: 1, cost: 1, cart_id: @cart.id, product_id: @product.id)
    @order = orders(:order_one)
    @order.update(cart: @cart)
    # @order.update(cartitem_id: @cartitem.id)
  end

  describe "instantiation" do

    it "can be instantiated" do    
      expect(@order.valid?).must_equal true
    end

    it "has the required fields" do
      [:status, :email, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip].each do |field|
        expect(@order).must_respond_to field
      end
    end
  end

  describe "validations" do

    it "requires billing information  about customer" do
      [:email, :name, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip].each do |field|
        @order.update("#{field}": nil)
        expect(@order.valid?).must_equal false
      end
    end
  end


  describe "relations" do

    it "belongs to a cart" do
      expect(@cart.order).must_equal @order
    end

  end


end
