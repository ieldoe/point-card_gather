Rails.application.routes.draw do

  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  root to: 'homes#top'
  resources :users, only: %i[show new create edit update destroy]
  resources :pointcards, only: %i[new ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
