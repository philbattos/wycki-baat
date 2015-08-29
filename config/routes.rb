Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-status/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'baats#index'

  resources :baats
  resources :models
  resources :content
  resources :pdf_originals
  resources :images

end
