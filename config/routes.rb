Rails.application.routes.draw do
  controller :sessions do
    get 'auth/:provider/callback' => :create
    get 'logout' => :destroy
  end

  scope '(:locale)' do
    root to: 'home#index'

    resources :exercises do
      resources :submissions, controller: 'exercise_submissions', only: [:new, :create, :show, :index]
    end
    resources :guides, only: [:new, :create, :show] do
      resources :imports, controller: 'guide_imports', only: [:create]
    end
    resources :submissions, only: :index
    resources :users, only: :show
  end

end
