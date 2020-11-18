Rails.application.routes.draw do
  resources :products

  root to: "products#index"
  # user routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "omniauth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

end
