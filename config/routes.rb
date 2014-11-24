Rails.application.routes.draw do

  root to: 'exercises#index'

  resources :exercises do
    resources :submissions, only: [:new, :create, :show, :index]
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

end
