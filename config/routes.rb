Rails.application.routes.draw do
  get 'analyses/index'
  root to: 'posts#index'
  resources :posts
  resources :labels, only: [:new, :create, :index, :edit, :update, :destroy ]
  resources :favorites, only: [:create, :destroy, :index ]
  resources :users, only: [:index]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
