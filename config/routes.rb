Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  controller :sessions do
    get 'auth/:provider/callback' => :create
    get 'logout' => :destroy
  end


  get '/es/exercises/:id', to: redirect('/exercises/%{id}')
  get '/en/exercises/:id', to: redirect('/exercises/%{id}')
  get '/es/guides/:id', to: redirect('/guides/%{id}')
  get '/en/guides/:id', to: redirect('/guides/%{id}')
  get '/es/guides', to: redirect('/guides')
  get '/en/guides', to: redirect('/guides')
  get '/es/exercises', to: redirect('/exercises')
  get '/en/exercises', to: redirect('/exercises')

  namespace :api do
    resources :exercises, only: :index
    resources :users, only: :index
    resources :guides, only: [:index, :create]
  end

  root to: 'home#index'

  resources :chapters, only: [:index, :show]

  # All users
  resources :exercises do
    # Current user
    resources :solutions, controller: 'exercise_solutions', only: :create
    resources :queries, controller: 'exercise_query', only: :create
  end

  # All users
  resources :guides, only: [:show, :index] do
    # All users
    member do
      post :collaborators_refresh
      get :details
    end
    # All users
    resources :exercises, controller: 'guide_exercises', only: :index
  end

  # All users
  resources :users, only: [:show, :index] do
    #nested user
    resources :solved_exercises, controller: 'user_solved_exercises', only: :index
    #nested user
    resources :assignments, controller: 'user_assignments', only: :index
  end
end
