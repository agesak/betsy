require "test_helper"

describe Product do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  describe "update cartitems" do
    it "can update a cartitems cost to match the product and the cart status must be pending" do
      # choose a product and change cost
      product = products(:product3)
      product.cost = 4234.00
      product.save


      # cartitem of the product above
      cartitem = cartitems(:cartitem5)

      # assert
      product.update_cartitems

      updated_cartitem = Cartitem.find_by(id: cartitem.id)

      expect(updated_cartitem.id).must_equal cartitem.id
      expect(updated_cartitem.cart).must_equal cartitem.cart
      expect(updated_cartitem.product).must_equal product
      expect(updated_cartitem.cart.status).must_equal "pending"
      expect(updated_cartitem.cost).must_equal 4234.00
    end

    it "should not update the cartitem if the cart status is not pending" do

      # choose a product and change cost
      product = products(:product5)
      product.cost = 385.00
      product.save


      # cartitem of the product above
      cartitem = cartitems(:cartitem4)

      # assert
      product.update_cartitems

      found_cartitem = Cartitem.find_by(id: cartitem.id)

      expect(found_cartitem.id).must_equal cartitem.id
      expect(found_cartitem.cart).must_equal cartitem.cart
      expect(found_cartitem.product).must_equal product
      expect(found_cartitem.cart.status).must_equal "paid"
      expect(found_cartitem.cost).wont_equal product.cost
    end
  end
end
