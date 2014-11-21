Rails.application.routes.draw do

  root to: 'exercises#index'

  resources :exercises do
    resources :submissions, only: [:new, :create, :show, :index]
  end

end
