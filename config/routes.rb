Rails.application.routes.draw do
  root to: 'posts#index'
  resources :posts
  resources :labels, only: [:new, :create, :index, :edit, :update, :destroy ]
  resources :favorites, only: [:create, :destroy, :index ]
  resources :users, only: [:index]
  resources :analyses, only: [:index]
  resources :top, only: [:index]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  post '/users/guest_sign_in', to: 'users#guest_sign_in'
end
