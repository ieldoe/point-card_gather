Rails.application.routes.draw do

  root to: 'homes#top'
  resources :users, only: %i[show new create edit update destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
