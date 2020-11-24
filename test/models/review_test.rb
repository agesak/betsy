require "test_helper"

describe Review do

  describe "relations" do
    it 'has a product' do
      r = reviews(:review1)
      expect(r).must_respond_to :product
      expect(r.product).must_be_kind_of Product
    end
  end

  describe "validations" do

    it "is valid when all fields are present" do
      p = products(:product0)
      review = Review.new(product: p, name: "Bobster", rating: 1)

      result = review.valid?
      expect(result).must_equal true

    end

    it "requires a name" do
      p = products(:product0)
      review = Review.new(product: p, rating: 1)
      result = review.valid?

      expect(result).must_equal false
      expect(review.errors.messages).must_include :name
    end

    it "requires a rating" do
      p = products(:product0)
      review = Review.new(product: p, name: "Terry Bob")
      result = review.valid?

      expect(result).must_equal false
      expect(review.errors.messages).must_include :rating
    end
  end
end
