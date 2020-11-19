Rails.application.routes.draw do
  get 'categories/index'
  resources :products

  resources :categories, only:[:index] do
    resources :products, only:[:index]
  end

  root to: "products#index"
  # user routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  get 'carts/:id', to: "carts#show", as: "cart"
end
