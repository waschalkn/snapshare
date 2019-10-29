Rails.application.routes.draw do
  devise_for :users
  root "shots#index"
  resources :shots
end
