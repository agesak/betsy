class CartsController < ApplicationController

  def show
    @cart = @current_cart
    @cartitems = @cart.cartitems.order(created_at: :desc)
  end

  def purchase_form
    @cart = @current_cart
  end

  def purchase

    @cart = @current_cart

    if @cart.update(cart_params)
      @cart.status = "paid"
      @cart.update_item_fulfillment

      @cart.save
      flash[:success] = "your stuff was ordered"

      @cart.update_inventory

      session[:cart_id] = nil
      current_cart
      redirect_to root_path
      return
    else
      flash.now[:error] = "your stuff wasnt ordered"
      render :purchase_form, status: :bad_request
      return
    end

  end

  private

  def cart_params
    return params.require(:cart).permit(:email, :mailing_address, :name, :cc_number,
                                        :cc_expiration, :cc_cvv, :zip)
  end

end
