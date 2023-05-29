Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
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

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

end
