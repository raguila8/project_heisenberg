Rails.application.routes.draw do
  get 'sessions/new'

  get '/signup', to: 'users#new'
	root 'static_pages#about'
	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
  resources :users, except: [:index]
	get '/friends', to: 'users#index'
	get '/find-friends', to: 'users#find_friends'
	delete '/unfriend', to: 'friendships#destroy'
	post '/friend', to: 'friendships#create'
	get '/archives', to: 'problems#index'
	resources :problems, only: [:show]
	post '/attempt', to: 'solved_problems#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
