Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :passengers#, only: [:index]
  resources :drivers
  resources :trips
  
  root 'homepages#index'
end
