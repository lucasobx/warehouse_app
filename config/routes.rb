Rails.application.routes.draw do
  root 'home#index'
  resources :warehouses, except: [:index]
  resources :suppliers, except: [:destroy]
  resources :product_models, only: [:index]
end
