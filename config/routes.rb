Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'queues#index'
  get '/queues/:id', to: 'queues#show'

end
