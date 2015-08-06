Rails.application.routes.draw do
  root 'home#index'
  resources :orders


  devise_for :users#, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
