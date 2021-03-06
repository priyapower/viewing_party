Rails.application.routes.draw do
  get '/', to: 'welcome#index', as: :welcome
  get '/discover', to: 'discover#show'

  get '/movies', to: 'movie#index'
  get '/movies/:id', to: 'movie#show'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/dashboard', to: 'users#show'
  post '/dashboard', to: 'sessions#create'
  get '/dashboard/signout', to: 'sessions#delete'
  post '/friends', to: 'users#add_friend'

  get '/:movie_id/party/new', to: 'parties#new'
  post '/:movie_id/party', to: 'parties#create'
end
