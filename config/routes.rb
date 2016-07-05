Rails.application.routes.draw do
  resources :rooms
  resources :users
  root to: 'rooms#index'
  mount ActionCable.server => '/cable'
end
