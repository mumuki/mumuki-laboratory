Rails.application.routes.draw do

  Mumukit::Login.configure_login_routes! self

  Mumukit::Platform.map_organization_routes!(self) do
    root to: 'book#show'

    concern :debatable do |options|
      resources :discussions, options.merge(only: [:index, :show, :create, :update, :destroy]) do
        post :subscription, on: :member
      end
    end

    concerns :debatable, controller: 'book_discussions', only: :index

    resources :discussions, only: [] do
      resources :messages, only: [:create, :destroy], controller: 'discussions_messages'
    end

    resources :book, only: [:show]
    resources :chapters, only: [:show], concerns: :debatable, debatable_class: 'Chapter' do
      resource :appendix, only: :show
    end

    # All users
    resources :exercises, only: :show do
      # Current user
      resources :confirmations, controller: 'exercise_confirmations', only: :create
      resources :solutions, controller: 'exercise_solutions', only: :create
      resources :queries, controller: 'exercise_query', only: :create
      resources :tries, controller: 'exercise_tries', only: :create
    end

    resources :exercises, only: :show, concerns: :debatable, debatable_class: 'Exercise'

    # All users
    resources :guides, only: :show do
      resource :progress, controller: 'guide_progress', only: :destroy
    end

    resources :lessons, only: :show, concerns: :debatable, debatable_class: 'Lesson'
    resources :complements, only: :show
    resources :exams, only: :show

    # All users
    resource :user, only: :show

    # Current user
    resources :messages, only: [:index, :create]
    get '/messages/errors' => 'messages#errors'

    # Routes by slug
    get '/guides/:organization/:repository' => 'guides#show_by_slug', as: :guide_by_slug
    get '/exercises/:organization/:repository/:bibliotheca_id' => 'exercises#show_by_slug', as: :exercise_by_slug
    get '/join/:code' => 'invitations#show', as: :invitation
    post '/join/:code' => 'invitations#join'
    get '/user/unsubscribe' => 'users#unsubscribe'
    put '/user' => 'users#update', as: :update_user

    # Route for reading messages
    post '/messages/read_messages/:exercise_id' => 'messages#read_messages', as: :read_messages

    # Organizations assets
    get '/theme_stylesheet'     => 'assets#theme_stylesheet'
    get '/extension_javascript' => 'assets#extension_javascript'


    namespace :api do
      organization_regexp = Regexp.new Mumukit::Platform::Organization::Helpers.valid_name_regex
      uid_regexp = /[^\/]+/

      resources :users, only: [:create, :update],  constraints: {id: uid_regexp}
      resources :organizations,
                    only: [:index, :show, :create, :update],
                    constraints: {id: organization_regexp}

      resources :courses, only: [:create]
      constraints(uid: uid_regexp) do
        '/courses/:organization/:course'.tap do |it|
          post "#{it}/students" => 'students#create'
          post "#{it}/students/:uid/attach" => 'students#attach'
          post "#{it}/students/:uid/detach" => 'students#detach'
          post "#{it}/teachers" => 'teachers#create'
          post "#{it}/teachers/:uid/attach" => 'teachers#attach'
          post "#{it}/teachers/:uid/detach" => 'teachers#detach'
        end
      end
    end
  end

  #Rescue not found routes
  get '*not_found', to: 'application#not_found'
end
