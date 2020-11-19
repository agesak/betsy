class CartitemsController < ApplicationController

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
    redirect_back fallback_location: root_path
  end

end
