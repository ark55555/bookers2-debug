Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'
  get 'top' => 'homes#top'
  get 'home/about' => 'homes#about'
  resources :users,only: [:show,:index,:edit,:update] do
    member do
      get :following, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  get 'search' => 'searches#search'
  
  resources :chats, only: [:show, :create]
end