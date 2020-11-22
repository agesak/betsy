class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :add_to_cart]
  before_action :require_login, only: [:new, :create]
  before_action :authorized?, only:[:edit, :update, :destroy]

  def index

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

  def authorized?
    unless @product.owner(@current_user)
      flash[:error] = "You are not authorized to do this."
      redirect_to products_path
      return
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

  def add_to_cart
    # check if product is already in the cart
    if @current_cart.products.include?(@product)
      # find the cart item
      cart_item = current_cart.cartitems.find_by(product_id: @product.id)
      # check if there is enough inventory
      if cart_item.qty < @product.inventory
        cart_item.qty += 1
        flash[:success] = "Successfully added to cart"
      else
        # not enough inventory
        flash[:error] = "Sorry, not enough inventory"
      end
    else
      # create a new cart item if it doesn't exist
      cart_item = Cartitem.new(cart: @current_cart, product: @product, qty: 1, cost: @product.cost )
      flash[:success] = "Successfully added to cart"
    end

    # save the cart item and redirect back to the product show page
    cart_item.save
    redirect_back fallback_location: product_path(@product)
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
