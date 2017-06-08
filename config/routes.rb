Rails.application.routes.draw do

  Mumukit::Login.configure_login_routes! self

  Mumukit::Platform.map_organization_routes!(self) do
    root to: 'book#show'

    resources :book, only: [:show]
    resources :chapters, only: [:show] do
      resource :appendix, only: :show
    end

    # All users
    resources :exercises, only: [:show, :index] do
      # Current user
      resources :confirmations, controller: 'exercise_confirmations', only: :create
      resources :solutions, controller: 'exercise_solutions', only: :create
      resources :queries, controller: 'exercise_query', only: :create
    end

    # All users
    resources :guides, only: [:show, :index]
    resources :lessons, only: [:show]
    resources :complements, only: [:show]
    resources :exams, only: [:show]

    # All users
    resource :user, only: [:show]

    namespace :api do
      resources :guides, only: [:create]
      resources :topics, only: [:create]
      resources :books, only: [:create]
      resources :organizations, only: [:index]
    end

    # Current user
    resources :messages, only: [:index, :create]
    get '/messages/errors' => 'messages#errors'

    # Routes by slug
    get '/guides/:organization/:repository' => 'guides#show_by_slug', as: :guide_by_slug
    get '/exercises/:organization/:repository/:bibliotheca_id' => 'exercises#show_by_slug', as: :exercise_by_slug

    # Route for reading messages
    post '/messages/read_messages/:exercise_id' => 'messages#read_messages', as: :read_messages
  end

  #Rescue not found routes
  get '*not_found', to: 'application#not_found'
end
