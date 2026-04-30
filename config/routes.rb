Rails.application.routes.draw do
  root 'home#index'

  #good job on nested routes
  devise_for :users

  resources :jobs do
    member do
      post :cover
      post :complete
    end
    resources :reviews, only: [:create]
  end

  resources :job_types do
    member do
      get :training_module
      get :take_quiz    
      post :submit_quiz 
      post :complete_training
    end
  end

  resources :users, only: [:show, :edit, :update]

  get 'pricing', to: 'pages#pricing'

  namespace :business do
    resources :subscriptions, only: [:create]
  end

end
