Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
  get '/', to: 'index#index'

  get '/author', to: 'index#author_list'

  post '/signin/new', to: 'signin#create'

  get '/signin/new', to: 'signin#new'

  post '/graphql', to: 'graphql#execute'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
