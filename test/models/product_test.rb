require "test_helper"

describe Product do

  before do # connect categories
    product = products(:product1)
    weights = categories(:category_weights)
    shoes = categories(:category_shoes)
    product.category_ids = [weights.id, shoes.id]
  end

  describe "custom model methods" do

    it "will authenticate a user as the owner of a product and return true" do
      user = users(:ada)
      product = products(:product1)
      result = product.owner(user)
      expect(result).must_equal true
    end

    it "will not authenticate a guest user not logged in" do
      user = nil
      product = products(:product1)
      result = product.owner(user)
      expect(result).must_equal false
    end

    it "will return false if the user is not the owner of a product" do
      user = users(:valentine)
      product = products(:product1)
      result = product.owner(user)
      expect(result).must_equal false
    end
  end

  describe "validations" do
    it "Product with valid fields passes" do
      product = products(:product1)
      expect(product.valid?).must_equal true
    end

    it "must have a name" do
      product = products(:product1)
      product.name = nil
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :name
    end

    it "needs a description" do
      product = products(:product1)
      product.description = nil
      expect(product.valid?).must_equal false
    end

    it "must have inventory" do
      product = products(:product1)
      product.inventory = nil
      expect(product.valid?).must_equal false
    end

    it "inventory must be numeric" do
      product = products(:product1)
      product.inventory = "FT66231H"
      expect(product.valid?).must_equal false
    end

    it "Inventory must be be positive" do
      product = products(:product1)
      product.inventory = -1
      expect(product.valid?).must_equal false
    end

    it "price needs to be numeric" do
      product = products(:product1)
      product.cost = "YYYY"
      expect(product.valid?).must_equal false
    end

    it "price needs to be positive" do
      product = products(:product1)
      product.cost = -1
      expect(product.valid?).must_equal false
    end

    it "Needs a photo url" do
      product = products(:product1)
      product.image = "https://placekitten.com/300/200"
      expect(product.valid?).must_equal true
    end

    it "Must have at least 1 category" do
      product = products(:product1)
      product.category_ids = []
      expect(product.valid?).must_equal false
    end

  end

  describe "relationships" do
    it "belongs to a user" do
      product = products(:product1)
      expect(product.user).must_be_instance_of User
    end

    it "Can have multiple categories" do
      product = products(:product1)
      weights = categories(:category_weights)
      shoes = categories(:category_shoes)

      product.category_ids = [weights.id, shoes.id]
      expect(product.valid?).must_equal true
    end

    it "can have many CartItems (can be added to many carts)" do
      product = products(:product1)
      cart1 = carts(:cart1)
      cart2 = carts(:cart2)

      cart_item_1 = Cartitem.new(cart: cart1, product: product, qty: 1, cost: product.cost )
      cart_item_2 = Cartitem.new(cart: cart2, product: product, qty: 1, cost: product.cost )

      expect(product.valid?).must_equal true
      expect(cart_item_1.valid?).must_equal true
      expect(cart_item_2.valid?).must_equal true
    end
  end
end
