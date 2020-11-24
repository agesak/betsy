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

    it "requires a rating between 1-5" do
      p = products(:product0)
      5.times do |i|
        review = Review.new(product: p, name: "Terry Bob", rating: i+1 )
        result = review.valid?
        expect(result).must_equal true
      end
    end

    it "invalid ratings for bogas ratings" do
      p = products(:product0)
      bogas_ratings = ["hello", 20, -10]
      bogas_ratings.each do |rating|
        review = Review.new(product: p, name: "Terry Bob", rating: rating )
        result = review.valid?
        expect(result).must_equal false
        expect(review.errors.messages).must_include :rating
      end
    end
  end
end
