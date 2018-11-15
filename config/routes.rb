Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants do
    collection do
      get "top", to: "restaurants#top"
    end
  end

  root to: 'restaurants#index'
end
