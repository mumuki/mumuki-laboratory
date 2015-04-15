Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  controller :sessions do
    get 'auth/:provider/callback' => :create
    get 'logout' => :destroy
  end

  scope '(:locale)' do
    root to: 'home#index'

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
      member do
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
      # nested user
      resources :submissions, controller: 'user_submissions', only: :index
      #nested user
      resources :solved_exercises, controller: 'user_solved_exercises', only: :index
    end

    # Current user
    resources :submissions, only: :index
  end
end
