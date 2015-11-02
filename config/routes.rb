Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'baats#index'

  resources :baats,         only: [:index, :create]
  resources :templates,     only: [:index, :create]
  resources :volumes,       only: [:index, :create]
  resources :pdf_originals, only: [:index, :create]
  resources :images,        only: [:index, :create]

end
