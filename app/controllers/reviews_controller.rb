class ReviewsController < ApplicationController

  def create
    product = Product.find_by(id: params[:product_id])
    if product.user == @current_user
      flash[:error] = 'You cannot review your own product'
      redirect_to product_path(product.id)
      return
    else
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
  end

  private

  def review_params
    return params.require(:review).permit(:name, :rating, :description)
  end
end
