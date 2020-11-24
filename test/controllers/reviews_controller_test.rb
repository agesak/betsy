require "test_helper"

describe ReviewsController do

  describe "create" do
    it "creates a review with valid information" do

      product = products(:product0)
      new_review = {
          review: {
              name: "Kristal Calimari",
              rating: 5,
              description: "Best product ever"

        }
      }

      expect {
        post product_reviews_path(product.id), params: new_review
      }.must_change "Review.count", 1

      expect(flash[:success]).must_equal "Thank you for your review!"
      must_respond_with :redirect
      must_redirect_to product_path(product)

    end

    it "will not create a new review for missing required information" do
      product = products(:product0)
      new_review = {
          review: {
              description: "Best product ever"
          }
      }

      expect {
        post product_reviews_path(product.id), params: new_review
      }.wont_change "Review.count"

      expect(flash[:error]).must_equal 'Review was not successfully created.'
      must_respond_with :redirect
      must_redirect_to product_path(product)

    end

  end
end
