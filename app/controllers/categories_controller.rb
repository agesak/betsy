class CategoriesController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Category was successfully created!'
      redirect_to products_path
      return
    else
      flash.now[:failure] = 'Category was not successfully created.'
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

end
