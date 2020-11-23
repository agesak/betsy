class ReviewsController < ApplicationController

  def create

    product = Product.find_by(id: params[:product_id])
    @review = Review.new(product: product, rating: params[:review][:rating], description: params[:review][:description] )
    @review.product = product
    if @review.save
      flash[:success] = 'Thank you for your review'
      redirect_to product_path(product.id)
      return
    else
      flash.now[:failure] = 'Review was not successfully created.'
      render product_path(product.id)
      return
    end
  end

end
