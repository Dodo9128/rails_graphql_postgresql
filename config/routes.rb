Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'

  get '/', to: 'index#index'

  get '/author', to: 'index#author_list'

  get '/author/:id', to: 'author#index'

  get '/author/update_info/:id', to: 'author#userinfo'

  patch '/author/update_info/:id', to: 'author#update_info'

  patch '/author/withdrawal/:id', to: 'author#withdrawal'

  get '/signin/new', to: 'signin#new'

  post '/signin/new', to: 'signin#create'

  get '/book/new/:id', to: 'book#new'

  post '/book/new/:id', to: 'book#create'

  get '/book/delete/:id/:book_id', to: 'book#before_delete'

  patch '/book/delete/:id/:book_id', to: 'book#delete'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
