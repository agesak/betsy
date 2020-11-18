Rails.application.routes.draw do
  resources :products

  root to: "products#index"
  # user routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

  get 'carts/:id', to: "carts#show", as: "cart"
end
