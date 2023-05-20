Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get '/datasets/upload'

  resources :datasets do
    collection { post :import }
  end

  resources :sources
  resources :sessions
  resources :datasets
  resources :bands
  resources :publications
end
