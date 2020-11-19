class ApplicationController < ActionController::Base

  before_action :current_cart

  def current_user
    # return user matching id from session variable
    return @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path
    end
  end

  def current_cart
    if session[:cart_id]
      # check if there is an existing session for the cart
      cart = Cart.find_by(id: session[:cart_id])
      @current_cart = cart
    else
      # create a new cart if there is no cart session
      # store the session cart_id
      @current_cart = Cart.create(status: "pending")
      session[:cart_id] = @current_cart.id
    end
  end

end
