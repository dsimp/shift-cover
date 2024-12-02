Rails.application.routes.draw do
 root 'home#index'

  devise_for :users

  resources :users, only: [:show, :edit, :update]
  resources :job_types
  resources :jobs

  
end
