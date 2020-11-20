Rails.application.routes.draw do
  get 'categories/new'
  get 'categories/create'
  get 'categories/index'

  resources :products do
    resources :cartitems, only:[:create]
  end


  resources :categories, only:[:index] do
    resources :products, only:[:index]
  end

  resources :categories, only:[:index, :new, :create]

  root to: "products#index"

  # Omniauth Login Route
  get "/auth/github", as: "github_login"
  # Omniauth Github callback route
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"

  # User routes
  delete "/logout", to: "users#destroy", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"

  # Nested Route (not tested) - to link to separate page for current user products
  #get "/user/:user_id/products", to: "products#index", as: "current_user_products"

  get 'carts/:id', to: "carts#show", as: "cart"
  get 'carts/:id/purchase', to: "carts#purchase_form", as: "purchase_form"
  patch 'carts/:id', to: "carts#purchase"

  resources :cartitems, only:[:create, :destroy]
  post 'cartitems/:id/add', to: "cartitems#add_qty", as: "add"
  post 'cartitems/:id/reduce', to: "cartitems#reduce_qty", as: "reduce"
end
