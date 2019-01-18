Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants do
    collection do
      get "top", to: "restaurants#top"
    end
    member do
      get "chef", to: "restaurants#chef"
    end
    resources :reviews, only: [:new, :create, :destroy]
  end

  namespace :admin do
    resources :restaurants, only: [:index]
  end

  root to: 'restaurants#index'
end
