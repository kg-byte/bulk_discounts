Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "application#welcome"
  get "/admin", to: "admin#show"
  get "merchants/:merchant_id/dashboard", to: "merchants#show"
  get "merchants/:merchant_id/items", to: "merchant_items#index"
  get "merchants/:merchant_id/invoices", to: "merchant_invoices#index"
  get 'merchants/:merchant_id/invoices/:invoice_id', to: 'merchant_invoices#show'
  get "merchants/:merchant_id/items/new", to: "merchant_items#new"
  post "merchants/:merchant_id/items", to: "merchant_items#create"
  get "merchants/:merchant_id/items/:item_id", to: "merchant_items#show"
  get "merchants/:merchant_id/items/:item_id/edit", to: "merchant_items#edit"

  patch 'merchants/:merchant_id/items', to: 'merchant_items#update'
  patch "merchants/:merchant_id/items/:item_id", to: "merchant_items#update"
  patch "merchants/:merchant_id/invoice_items/:invoice_item_id", to: "invoice_items#update"

  namespace :admin do
    resources :merchants, only: [:index, :show, :new, :create, :edit, :update]
    resources :invoices, only: [:index, :show, :update]
  end

  resources :merchants, only: [:show] do 
    resources :bulk_discounts, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

end
