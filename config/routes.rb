Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'episodes#index'
  get '/episodes/:id', to: 'episodes#show'

end
