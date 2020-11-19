class CartsController < ApplicationController

  def show
    @cart = @current_cart
  end

  def purchase_form
    @cart = @current_cart
  end

  def purchase

    @cart = @current_cart

    # @cart.update(cart_params)
    if @cart.update(email: params[:email_address], mailing_address: params[:mailing_address],
                    name: params[:name], cc_number: params[:credit_card_number], cc_expiration: params[:credit_card_expiration],
                    cc_cvv:params[:cvv], zip: params[:zipcode])
      @cart.status = "paid"
      @cart.save
      flash[:success] = "your stuff was ordered"
      redirect_to root_path
      return
    else
      flash.now[:error] = "your stuff wasnt ordered"
      render :purchase_form, status: :bad_request
      return
    end

  end

  # private
  #
  # def cart_params
  #   return params.require(:cart).permit(:email_address, :mailing_address, :name, :cc_number,
  #                                       :cc_expiration, :cc_cvv, :zip)
  # end

end
