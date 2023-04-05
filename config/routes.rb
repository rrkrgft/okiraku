Rails.application.routes.draw do
  root to: 'posts#index'
  resources :posts
  resources :labels, only: [:new, :create, :index, :edit, :update, :destroy ]
  resources :favorites, only: [:create, :destroy ]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
