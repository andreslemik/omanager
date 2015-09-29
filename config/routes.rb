Rails.application.routes.draw do
  root 'home#index'

  devise_for :users # , ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :orders do
    get :internals, on: :collection
    resources :order_items, shallow: true
  end

  resources :partners, only: [:index, :show]
  resources :accounts
  resources :fabrication, only: [:index, :edit, :update] do
    collection do
      get 'schedule'
      get 'to_order'
      get 'print_schedule', defaults: { format: 'xlsx' }, as: :print_schedule
      get 'print_orders/:manufacturer_id', action: :print_orders,
                                           defaults: { format: 'xlsx' },
                                           as: :print_orders
    end
    put :get_ready, on: :member
  end

  resources :delivery, only: [:index, :edit, :update] do
    get :schedule, on: :collection
    get 'print_schedule/:sdate', on: :collection,
        action: :print_schedule, defaults: { format: 'xlsx' },
        as: :print_schedule
    put :well_done, on: :member
  end

  get 'products/by_category_mfc/:category_id/:manufacturer_id',
      to: 'products#by_category_mfc', defaults: { format: 'json' }
  get 'products/manufacturers/:category_id',
      to: 'products#manufacturers', defaults: { format: 'json' }
  get 'products/price/:product_id/:type_id(/:mods)',
      to: 'products#price', defaults: { format: 'json' }
  get 'products/option_values/:product_id(/:attr_id)',
      to: 'products#option_values'
end
