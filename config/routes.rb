Rails.application.routes.draw do
  root 'home#index'
  resources 'warehouses', except: [:destroy]
end
