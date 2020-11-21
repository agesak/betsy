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
    it "requires billing information and mailing information about customer when status is not pending" do
      @cart.email =  nil
      @cart.mailing_address = nil
      @cart.name = nil
      @cart.cc_number = nil
      @cart.cc_expiration = nil
      @cart.cc_cvv = nil
      @cart.zip = nil

      ["paid", "complete", "cancelled"].each do |status|
        @cart.status = status
        expect(@cart.valid?).must_equal false
      end
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
end
