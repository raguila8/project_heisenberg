Rails.application.routes.draw do
  get 'sessions/new'

  get '/signup', to: 'users#new'
	root 'static_pages#about'
	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
