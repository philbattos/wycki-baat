Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-status/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'baats#index'

  resources :baats, only: [:index, :create] do |baat|
    # collection { get :events } # for streaming via ActionController::Live
  end
  resources :models
  resources :content
  resources :pdf_originals
  resources :images
end
