Rails.application.routes.draw do
  get 'upvotes/new'

  get 'sessions/new'

  get '/signup', to: 'users#new'
	root 'static_pages#about'
	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
  resources :users, except: [:index]
	get '/leaderboards', to: 'users#leaderboards', as: :leaderboards
	get '/leaderboard_filter', to: 'users#leaderboard_filter', as: :leaderboard_filter
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
	resources :messages, only: [:create, :index]
	resources :conversations, only: [:show, :index, :create]

	get '/math-formatting', to: 'static_pages#math_formatting'

	post '/comments', to: 'comments#create', as: :comments
	delete '/comments', to: 'comments#destroy', as: :destroy_comment
	get '/get_comments', to: 'comments#get_comments', as: :get_comments
	get '/comments/:id/edit', to: 'comments#edit', as: :edit_comment
	patch '/comments/:id', to: 'comments#update', as: :comment
	resources :subtopics, only: [:show]
	resources :branches, only: [:show, :index]
	get '/problems_filter', to: 'branches#problems_filter', as: :problems_filter

	post '/follow', to: 'relationships#create', as: :follow
	get '/unfollow', to: 'relationships#destroy', as: :unfollow
	get '/autocomplete', to: 'users#autocomplete', as: :autocomplete


	# script tags
	mathjax 'mathjax'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
