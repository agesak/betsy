class CartitemsController < ApplicationController

  before_action :find_cartitem, except: [:create]

  def create
    # product nested route
    product_id = params[:product_id]
    product = Product.find_by(id: product_id)
    current_cart = @current_cart

    # check if product is already in the cart
    if current_cart.products.include?(product)

      # find the cart item
      @cart_item = current_cart.cartitems.find_by(product_id: product_id)
      # check if there is enough inventory
      if @cart_item.qty < product.inventory
        @cart_item.qty += 1
      else
        # not enough inventory
        redirect_back fallback_location: root_path
        flash[:error] = "Sorry, not enough inventory"
        return
      end
    else
      # create a new cart item if it doesn't exist
      @cart_item = Cartitem.new(cart_id: current_cart.id, product_id: product_id, qty: 1, cost: product.cost )
    end

    # save the cart item and redirect back to the product show page
    @cart_item.save
    flash[:success] = "Successfully added to cart!"
    redirect_back fallback_location: root_path
  end

  def add_qty
    # find the product
    product_inventory = @cart_item.product.inventory

    if @cart_item.qty < product_inventory
      @cart_item.qty += 1
      @cart_item.save
    else
      # not enough inventory
      flash[:error] = "Sorry, not enough inventory"
    end
    redirect_to cart_path
  end

  def reduce_qty
    if @cart_item.qty > 1
      @cart_item.qty -= 1
    end
    @cart_item.save

    redirect_to cart_path
  end

  def destroy
    @cart_item.destroy
    redirect_to cart_path

  end

  private

  def find_cartitem
    cart_item_id = params[:id]
    @cart_item = Cartitem.find_by(id: cart_item_id)
  end
end
