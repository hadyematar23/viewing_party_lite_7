Rails.application.routes.draw do

  get "/dashboard", to: "users#dashboard", as: "user_dashboard"
  get "/dashboard/discover", to: "users#discover", as: "user_discover_dashboard"
  get "/", to: "landing#index", as: "landing"
  get "/register", controller: 'users', to: "users#new"
  get "/login", to: "users#login_form"

  resources :sessions, only: [:destroy, :create]
  resources :users, only: [:new, :create, :show] 
  resources :movies, only: [:index, :show] do 
    resources :parties, only: [:new, :create]
  end
  namespace :admin do 
    get "/users/:id", to: "users#show"
    get "/dashboard", to: "users#dashboard"
  end


end
