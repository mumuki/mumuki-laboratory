Rails.application.routes.draw do

  root to: 'home#index'

  resources :exercises do
    resources :submissions, controller: 'exercise_submissions', only: [:new, :create, :show, :index]
  end

  resources :submissions, only: :index

  get 'auth/:provider/callback', to: 'sessions#create'

  get 'logout', to: 'sessions#destroy'

end
