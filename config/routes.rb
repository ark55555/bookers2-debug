Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'
  get 'top' => 'homes#top'
  get 'home/about' => 'homes#about'
  get 'search' => 'searches#search'
  resources :users,only: [:show,:index,:edit,:update] do
    member do
      get :following, :followers
    end
    resource :relationships, only: [:create, :destroy]
    get "search" => "users#search"
  end

  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  resources :chats, only: [:show, :create]
  
  resources :groups do
    get "join" => "groups#join"
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end
  
end