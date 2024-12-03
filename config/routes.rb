Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  resources :jobs do
    member do
      post :cover
    end
  end

  resources :job_types do
    member do
      get :training_module
      post :complete_training
    end
  end

  resources :users, only: [:show, :edit, :update]

end
