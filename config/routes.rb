Rails.application.routes.draw do
  controller :sessions do
    get 'auth/:provider/callback' => :create
    get 'logout' => :destroy
  end

  scope '(:locale)' do
    root to: 'home#index'
    # All users
    resources :exercises do
      # Current user
      resources :submissions, controller: 'exercise_submissions', only: [:new, :create, :show, :index]
    end

    # Current user
    resources :guides, only: [:new, :create, :show, :index] do
      # Current user
      resources :imports, controller: 'guide_imports', only: [:create]
    end

    # Current user
    resources :submissions, only: :index

    # All users
    resources :users, only: :show do
      # Nested user
      resources :exercises, controller: 'user_exercises', only: :index
    end
  end

end
