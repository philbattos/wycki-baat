Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'baats#index'

  resources :baats,         only: [:index, :create]
  resources :templates,     only: [:index, :create]
  resources :volumes,       only: [:index, :create]
  resources :images,        only: [:index, :create]

  get   '/pdfs', to: 'pdf_originals#index', as: 'pdf_originals'
  post  '/pdfs', to: 'pdf_originals#create'

end
