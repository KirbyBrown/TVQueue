Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'queued_episodes#index'
  get '/queues/:id', to: 'queues#show'

  get '/tv_shows/search', to: 'tv_shows#search'
  post '/tv_shows/search', to: 'tv_shows#search_results'
  get '/tv_shows/add', to: 'tv_shows#add'
  get '/tv_shows/remove', to: 'tv_shows#remove'
  post 'tv_shows/mass_mark_viewed', to: 'tv_shows#mass_mark_viewed'

  get '/queued_episodes/toggle_viewed_status', to: 'queued_episodes#toggle_viewed_status'
  get '/queued_episodes/index', to: 'queued_episodes#index'

  get '/static_pages/help', to: 'static_pages#help'
end
