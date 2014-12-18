Rails.application.routes.draw do

  scope '(:locale)' do
    root to: 'home#index'

    resources :exercises do
      resources :submissions, controller: 'exercise_submissions', only: [:new, :create, :show, :index]
    end
    resources :submissions, only: :index
  end

  controller :sessions do
    get 'auth/:provider/callback' => :create
    get 'logout' => :destroy
  end
end
