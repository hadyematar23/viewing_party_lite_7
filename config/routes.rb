Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/", to: "landing#index"

  resources :users, only: [:new, :create] do 
    resources :movies, only: [:index, :show], controller: 'user_movies' do 
      resources :parties, only: [:new, :create]
    end
  end
  
  get "/users/:id", to: "users#dashboard", as: "user_dashboard"
  get "/users/:id/discover", to: "users#discover"

  get "/register", controller: 'users', to: "users#new"
  get "/login", to: "users#login_form"
  post "/login", to: "users#login_user"
end
