Rails.application.routes.draw do
  resources :publications
  resources :bands
  resources :datasets
  resources :sessions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :sources
  resources :sessions
  resources :datasets
  resources :bands
  resources :publications
end
