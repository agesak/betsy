class ApplicationController < ActionController::Base

  before_action :current_cart, :current_user, :categories, :merchants, :category

  def categories
    @categories = Category.all
  end

  def merchants
    @merchants = User.merchants
  end

  def category
    @category = Category.new
  end

  def current_user
    # return user matching id from session variable
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user = nil
    end
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
