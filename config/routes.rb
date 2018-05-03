Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'queued_episodes#index'
  get '/queues/:id', to: 'queues#show'

  get '/tv_shows/search', to: 'tv_shows#search'
  post '/tv_shows/search', to: 'tv_shows#search_results'

end
