require "test_helper"

describe Order do

  before do
    @cart = Cart.create!
    @order = orders(:order_one)
    @order.update(cart: @cart)
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
