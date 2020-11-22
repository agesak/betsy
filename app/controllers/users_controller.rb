class UsersController < ApplicationController

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
    @current_user_cart_items = @current_user.cartitems

    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
      return
    end
  end

  def fulfillment

    @pending_orders = merchant_orders(@current_user, status = "pending")

    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
      return
    end
  end

end
