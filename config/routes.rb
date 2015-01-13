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
      # All users
      resources :imports, controller: 'guide_imports', only: :create
      # All users
      resources :exercises, controller: 'guide_exercises', only: :index
    end

    # Current user
    resources :submissions, only: :index
    resources :languages

    # All users
    resources :users, only: :show do
      # Nested user
      resources :exercises, controller: 'user_exercises', only: :index
    end
  end

end
