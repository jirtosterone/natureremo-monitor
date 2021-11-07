Rails.application.routes.draw do
  root 'monitor#index'
  get 'monitor/index'
  resources :events
  resources :devices
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
