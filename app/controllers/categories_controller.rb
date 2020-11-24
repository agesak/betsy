class CategoriesController < ApplicationController
  before_action :require_login

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
      flash[:failure] = 'Category was not successfully created.'
      redirect_to products_path
      return
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name, :banner_img)
  end

end
