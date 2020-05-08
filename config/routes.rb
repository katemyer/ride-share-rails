Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :drivers, only: [:index, :show, :create, :new]
  
  resources :passengers 
  
  resources :trips
  
  root 'homepages#index'
end
