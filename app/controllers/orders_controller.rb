class OrdersController < ApplicationController

  def new
    @cart = @current_cart
  end

  def create
    @cart = @current_cart

    order = Order.new(status: "paid", email: params[:email_address],
                      mailing_address:params[:mailing_address], name:params[:name],
                      cc_number:params[:credit_card_number], cc_expiration:params[:credit_card_expiration],
                      cc_cvv:params[:cvv], zip:params[:zipcode], cart:@cart)

    if order.save
      flash[:success] = "your stuff was ordered"
      # TODO: Reduces the number of inventory for each product
    else
      # Clears the current cart
      flash[:error] = "your stuff wasnt ordered"
    end
    redirect_to root_path

  end

end
