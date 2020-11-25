class ReviewsController < ApplicationController

  def create
    product = Product.find_by(id: params[:product_id])
    @review = Review.new(review_params)

    @review.product = product
    if @review.save
      flash[:success] = 'Thank you for your review!'
      redirect_to product_path(product.id)
      return
    else
      flash[:error] = 'Review was not successfully created.'
      flash[:error_message] = @review.errors.messages
      redirect_to product_path(product.id)
      return
    end
  end

  private

  def review_params
    return params.require(:review).permit(:name, :rating, :description)
  end
end
