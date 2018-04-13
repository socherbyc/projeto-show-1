Rails.application.routes.draw do
  get "/clients/:id/orders", to: "clients#orders_index", as: :client_orders
  get "/clients/:id/orders/:number", to: "clients#orders_show", as: :client_orders_show, id: /\d+/, number: /\d+/
  get "/clients/:id/orders/new", to: "clients#orders_new", as: :client_orders_new, id: /\d+/
  post "/clients/:id/orders", to: "clients#orders_create", as: :client_orders_create, id: /\d+/

  resources :order_details, only: [:index, :new, :create]
  resources :products
  resources :addresses
  resources :orders
  resources :clients
  get "/", to: "index#index", as: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/order_details/:order_number/:product_id" => "order_details#show", as: :order_details_show, order_number: /\d{1,7}/, product_id: /\d{1,7}/
  get "/order_details/:order_number/:product_id/edit" => "order_details#edit", as: :order_details_edit, order_number: /\d{1,7}/, product_id: /\d{1,7}/
  match "/order_details/:order_number/:product_id", to: "order_details#update", as: :order_details_update, order_number: /\d{1,7}/, product_id: /\d{1,7}/, via: [:put, :patch]
  match "/order_details/:order_number/:product_id", to: "order_details#destroy", as: :order_details_destroy, order_number: /\d{1,7}/, product_id: /\d{1,7}/, via: :delete
end
