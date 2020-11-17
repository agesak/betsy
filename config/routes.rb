Rails.application.routes.draw do
  resources :products

  # user routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"


end
