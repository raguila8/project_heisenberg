Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]
	devise_scope :user do
		get '/sign_in', to: 'devise/sessions#new', as: :new_user_session
		post '/sign_in', to: 'devise/sessions#create', as: :user_session
  	delete '/sign_out', to: 'devise/sessions#destroy', as: :logout
		get 'cancel_registration', to: 'registrations#cancel', as: :cancel_user_registration
		get 'sign_up', to: 'registrations#new', as: :signup
		get 'change_password/:id', to: 'registrations#edit', as: :edit_user_registration
		patch '/change_password/:id', to: 'registrations#update', as: :update_edit_user_registration
		put '/user_registration', to: 'registrations#update'
		delete '/user_registration', to: 'registrations#destroy'
		post '/user_registration', to: 'registrations#create'
		authenticated :user do
			root 'problems#index'
		end
		
		unauthenticated do
			root 'static_pages#landing_page'
		end

	end

  get 'upvotes/new'

  get 'sessions/new'

  #get '/signup', to: 'users#new'
	get '/landing', to: 'static_pages#landing_page', as: :landing_page
	get '/about', to: 'static_pages#about', as: :about
	get '/attributions', to: 'static_pages#attributions', as: :attributions
	#get '/login', to: 'sessions#new'
	#post '/login', to: 'sessions#create'
	#delete '/logout', to: 'sessions#destroy'
  resources :users, only: [:show, :edit, :update]
	get '/leaderboards', to: 'users#leaderboards', as: :leaderboards
	get '/leaderboard_filter', to: 'users#leaderboard_filter', as: :leaderboard_filter
	get '/friends', to: 'users#index'
	get '/find-friends', to: 'users#find_friends'
	delete '/unfriend', to: 'friendships#destroy'
	post '/friend', to: 'friendships#create'
	get '/dashboard', to: 'problems#index', as: :dashboard
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
	resources :subtopics, only: [:show, :new, :create]
	resources :branches, only: [:show, :index, :new, :create]
	get '/problems_filter', to: 'branches#problems_filter', as: :problems_filter

	post '/follow', to: 'relationships#create', as: :follow
	get '/unfollow', to: 'relationships#destroy', as: :unfollow
	get '/autocomplete', to: 'users#autocomplete', as: :autocomplete
	get '/recently_solved_problems', to: 'users#recently_solved_problems', as: :recently_solved_problems

	################################ NOTIFICATIONS #############################
	get '/read_notifications', to: 'notifications#read_notifications', 
																						as: :read_notifications

	patch '/update_profile_img', to: 'users#update_profile_image', as: :update_profile_image

	get '/edit_profile/:id', to: 'users#edit_profile', as: :edit_profile
	patch '/edit_profile/:id', to: 'users#update_profile', as: :update_profile

	# script tags
	mathjax 'mathjax'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
