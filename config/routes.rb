Rails.application.routes.draw do
  get "/order_details/:order_number/:product_id" => "order_details#show", as: :order_details_show, order_number: /\d{1,7}/, product_id: /\d{1,7}/
  get "/order_details/:order_number/:product_id/edit" => "order_details#edit", as: :order_details_edit, order_number: /\d{1,7}/, product_id: /\d{1,7}/
  match "/order_details/:order_number/:product_id", to: "order_details#update", as: :order_details_update, order_number: /\d{1,7}/, product_id: /\d{1,7}/, via: [:put, :patch]
  match "/order_details/:order_number/:product_id", to: "order_details#destroy", as: :order_details_destroy, order_number: /\d{1,7}/, product_id: /\d{1,7}/, via: :delete
  get "/orders/new-complete", to: "orders#new_complete", as: :order_new_complete
  resources :order_details, only: [:index, :new, :create]
  resources :products
  resources :addresses
  resources :orders
  resources :clients
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
