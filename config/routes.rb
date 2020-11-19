Rails.application.routes.draw do
  get 'categories/index'
  resources :products do
    resources :cartitems, only:[:create]
  end

  resources :categories, only:[:index]

  root to: "products#index"
  # user routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  get 'carts/:id', to: "carts#show", as: "cart"

  resources :cartitems, only:[:create, :destroy]

  post 'cartitems/:id/add', to: "cartitems#add_qty", as: "add"
  post 'cartitems/:id/reduce', to: "cartitems#reduce_qty", as: "reduce"
end
