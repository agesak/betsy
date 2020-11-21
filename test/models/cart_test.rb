require "test_helper"

describe Cart do

  before do
    @cart = carts(:cart0)
    @cartitem0 = cartitems(:cartitem0)
    @cartitem1 = cartitems(:cartitem1)
  end

  describe "instantiation" do
    it "can be instantiated" do
      expect(@cart.valid?).must_equal true
    end

    it "has the required fields" do
      [:status, :email, :mailing_address, :name, :cc_number, :cc_expiration, :cc_cvv, :zip].each do |field|
        expect(@cart).must_respond_to field
      end
    end
  end

  describe "validations" do
    it "requires billing information  about customer when status is paid" do
      skip
    end
  end

  describe "relations" do

    it "has many cartitems" do
      expect(@cart.cartitems.length).must_equal 2
    end

    it "has_many products through cartitems" do
      expect(@cart.products.length).must_equal 2
    end
  end

  describe "update inventory" do

    it "updates the inventory after an order purchase" do

      product1 = @cartitem0.product
      product2 = @cartitem1.product
      expect(product1.inventory).must_equal 10
      expect(product2.inventory).must_equal 5


      @cart.update_inventory

      p updated_product1 = @cart.cartitems.first.product
      p updated_product2 = @cart.cartitems.last.product

      expect(updated_product1.id).must_equal product1.id
      expect(updated_product1.inventory).must_equal 6
      expect(updated_product2.id).must_equal product2.id
      expect(updated_product2.inventory).must_equal 1

      Product.all.each do |x|
        p x
        end 



    end

  end
end
