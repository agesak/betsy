class UsersController < ApplicationController
  before_action :require_login, only: [:current, :fulfillment, :destroy]

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      flash[:success] = "Logged in as returning user #{user.username}"
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.username}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
    return
  end

  def current
    @current_user_products = @current_user.products
  end

  def fulfillment
    # merchant_orders returns a hash where the key is the cart id, the value is the cart
    @pending_orders = @current_user.merchant_orders(status = "pending")
    @paid_orders = @current_user.merchant_orders(status = "paid")
    @complete_orders = @current_user.merchant_orders(status = "complete")
  end
end
