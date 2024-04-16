Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :warehouses, except: [:index]
  resources :suppliers, except: [:destroy]
  resources :product_models, except: [:destroy]
  resources :orders, only: [:show, :new, :create]
end
