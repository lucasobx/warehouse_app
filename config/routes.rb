Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :stock_product_destinations, only: [:create]
  end
  resources :suppliers, only: [:index, :show, :new, :create, :edit, :update]
  resources :product_models, only: [:index, :show, :new, :create, :edit, :update]
  resources :orders, only: [:show, :new, :create, :edit, :update, :index] do
    resources :order_items, only: [:new, :create]
    get 'search', on: :collection
    post 'delivered', on: :member
    post 'canceled', on: :member
  end
end
