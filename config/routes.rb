Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, only: [:index]
  resources :orders, only: [:create, :index]
  post 'products/search' => 'products#search'
  get '/order/download' => 'orders#download_article'
  root "home#index"
end
