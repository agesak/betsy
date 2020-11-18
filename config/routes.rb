Rails.application.routes.draw do
  get 'categories/index'
  resources :products

  root to: "products#index"
  # user routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"


end
