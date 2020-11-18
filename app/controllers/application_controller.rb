class ApplicationController < ActionController::Base

  before_action :current_cart

  def current_cart
    if session[:cart_id]
      # check if there is an existing session for the cart
      cart = Cart.find_by(id: session[:cart_id])
      @current_cart = cart
    else
      # create a new cart if there is no cart session
      # store the session cart_id
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
  end

end
