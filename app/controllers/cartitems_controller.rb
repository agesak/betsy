class CartitemsController < ApplicationController

  before_action :find_cartitem, except: [:create]

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

  def update_status
    @cart_item.assign_attributes(fulfillment_status: "order shipped")
    if @cart_item.save
      cart = @cart_item.cart
      cart.complete_cart
      redirect_back fallback_location: '/'
      return
    else
      flash[:error] = "Sorry, status not changed. Please try again."
      redirect_back fallback_location: '/'
    end
  end

  private

  def find_cartitem
    cart_item_id = params[:id]
    @cart_item = Cartitem.find_by(id: cart_item_id)
  end
end
