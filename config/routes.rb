require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # TODO: Add username and password later.
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index create update] do
        member do
          post :sync, to: 'profile_syncs#create'
        end
      end
    end
  end

  get '/:nanoid', to: 'links#show'
end
