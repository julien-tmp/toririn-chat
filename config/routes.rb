Rails.application.routes.draw do

  root to: 'root#index'


  # get :about, to: 'root#about'


  devise_for :users, controllers: { confirmations: 'confirmations' }

  resources :rooms

  get :teacher, to: 'teacher#index'
  namespace :teacher do
    resources :rooms do
      resources :messages do
        collection do
          delete :destroy_all
        end
      end
    end
  end
  resources :users
  delete :logout, to:'sessions#destroy'
  mount ActionCable.server => '/cable'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

end
