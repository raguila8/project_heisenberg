Rails.application.routes.draw do
  get 'upvotes/new'

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
	resources :problems, only: [:show, :create, :edit, :destroy, :update, :new]
	post '/attempt', to: 'solved_problems#create'
	resources :topics, only: [:show]
	resources :posts, only: [:new, :edit, :create, :update, :destroy]
	#get '/posts/:id/edit', to: 'posts#edit'
	put 'like', to: 'topics#vote'
	post '/message', to: 'conversations#create'
	resources :messages, only: [:create]
	resources :conversations, only: [:show]

	get '/math-formatting', to: 'static_pages#math_formatting'

	post '/comments', to: 'comments#create', as: :comments
	delete '/comments', to: 'comments#destroy', as: :destroy_comment
	get '/get_comments', to: 'comments#get_comments', as: :get_comments



	# script tags
	mathjax 'mathjax'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
