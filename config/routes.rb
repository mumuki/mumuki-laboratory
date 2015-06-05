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
    resources :submissions, only: :index
    resources :users, only: :index
  end

  root to: 'home#index'

  resources :categories, only: :index

  # All users
  resources :exercises do
    # Current user
    resources :submissions, controller: 'exercise_submissions', only: [:create, :show, :index] do
      get :status
      get :results
    end
  end

  # All users
  resources :guides, only: [:new, :create, :show, :edit, :index, :update] do
    # All users
    resources :contributors, controller: 'guide_contributors', only: [:index]
    member do
      post :collaborators_refresh
      get :details
    end
    # All users
    resources :imports, controller: 'guide_imports', only: [:create, :index]
    resources :exports, controller: 'guide_exports', only: [:create, :index]
    # All users
    resources :exercises, controller: 'guide_exercises', only: :index
  end

  # All users
  resources :users, only: [:show, :index] do
    # Nested user
    resources :exercises, controller: 'user_exercises', only: :index
    # Nested user
    resources :guides, controller: 'user_guides', only: :index
    #nested user
    resources :solved_exercises, controller: 'user_solved_exercises', only: :index
    member do
      get :following, :followers
    end

    resources :relationships, only: [:create, :destroy]

    # Current user
    resources :submissions, only: :index
  end
end
