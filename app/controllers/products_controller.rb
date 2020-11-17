class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
    if @product.nil?
      head :not_found
      return
    end
  end

  def new
    @product = Product.new
  end

  def edit
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def create
    @product = Product.new(product_params)

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
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
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
    if @product.nil?
      head :not_found
      return
    else
      @product.destroy
      flash[:success] = "Product was successfully deleted."
      redirect_to products_path
      return
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    return params.require(:product).permit(:name, :cost, :inventory, :description, :image)
  end
end
