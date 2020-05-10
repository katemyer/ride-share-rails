Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :drivers#, only [:index, :show, :create, :new, :edit, :update, :destroy]
  
  resources :passengers, only: [:index, :show, :create, :new, :edit, :update, :destroy]
  
  resources :trips, only: [:index, :show, :create, :new, :edit, :update, :destroy]
  
  root 'homepages#index'
end
