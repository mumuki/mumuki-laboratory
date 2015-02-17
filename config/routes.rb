Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  controller :sessions do
    get 'auth/:provider/callback' => :create
    get 'logout' => :destroy
  end

  scope '(:locale)' do
    root to: 'home#index'

    get 'dashboard' => 'dashboard#show'

    # All users
    resources :exercises do
      # Current user
      resources :submissions, controller: 'exercise_submissions', only: [:new, :create, :show, :index] do
        get :status
        get :results
      end
    end

    # All users
    resources :guides, only: [:new, :create, :show, :index] do
      # All users
      resources :imports, controller: 'guide_imports', only: :create
      # All users
      resources :exercises, controller: 'guide_exercises', only: :index
    end

    # All users
    resources :users, only: :show do
      # Nested user
      resources :exercises, controller: 'user_exercises', only: :index
      # Nested user
      resources :guides, controller: 'user_guides', only: :index
    end

    # Current user
    resources :submissions, only: :index
    resources :languages
  end
end
