class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @merchants = User.merchants

    if params[:category_id]
      @category = Category.find(params[:category_id])
      @products = @category.products
    elsif params[:user_id]
      @merchant = User.find(params[:user_id])
      @products = @merchant.products
    else
      @products = Product.all
    end

  end

  def show

  end

  def new
    @product = Product.new
  end

  def edit

  end

  def create

    @product = @current_user.products.new(product_params)

    if @product.save
      flash[:success] = 'Product was successfully created!'
      redirect_to product_path(@product)
      return
    else
      flash.now[:failure] = 'Product was not successfully created.'
      render :new, status: :bad_request
      return
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = 'Product was successfully updated!'
      redirect_to product_path(@product)
      return
    else
      flash.now[:failure] = "Product was not successfully updated."
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = "Product was successfully deleted."
      redirect_to products_path
      return
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    end
  end

  def product_params
    return params.require(:product).permit(:name, :cost, :inventory, :description, :image, category_ids: [])
  end

end
