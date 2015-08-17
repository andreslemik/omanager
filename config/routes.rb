Rails.application.routes.draw do
  root 'home#index'
  resources :orders

  resources :partners, only: [:index, :show]
  resources :accounts

  devise_for :users#, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
