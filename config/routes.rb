Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'products#index', as: :authenticated_root
    end

    unauthenticated do
      root 'home#index', as: :unauthenticated_root
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, only: [:index]
  resources :orders, only: [:create, :index]
  get 'products/search' => 'products#search'
  get '/order/download' => 'orders#download_article'
  post '/product/rate' => 'products#rate'
  get '/paypal/checkout', to: 'orders#paypal_checkout'
  get '/paypal/complete', to: 'orders#complete_payment'
  # root "home#index"
end
