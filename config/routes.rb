Rails.application.routes.draw do
  root "shots#index"
  resources :shots, only: [:new, :create]
end
