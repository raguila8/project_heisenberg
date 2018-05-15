Rails.application.routes.draw do
  # Begin Devise
  devise_for :users, skip: [:sessions, :registrations]
	devise_scope :user do
		get '/sign_in', to: 'sessions#new', as: :new_user_session
		post '/sign_in', to: 'sessions#create', as: :user_session
  	delete '/sign_out', to: 'sessions#destroy', as: :logout
		get 'cancel_registration', to: 'registrations#cancel', as: :cancel_user_registration
		get 'sign_up', to: 'registrations#new', as: :signup
		get 'change_password/:id', to: 'registrations#edit', as: :edit_user_registration
		patch '/change_password/:id', to: 'registrations#update', as: :update_edit_user_registration
		put '/user_registration', to: 'registrations#update'
		delete '/user_registration', to: 'registrations#destroy'
		post '/user_registration', to: 'registrations#create'

		authenticated :user do
			root 'branches#index'
		end
		
		unauthenticated do
			root 'static_pages#landing_page'
		end
	end
  # End Devise

  get 'upvotes/new'

  # Begin SolvedProblems
	post '/attempt', to: 'solved_problems#create'
  # End SolvedProblems

  # Begin Topics
	resources :topics, only: [:show]
	put 'like', to: 'topics#vote'
  # End Topics

  # Begin Relationships
	post '/follow', to: 'relationships#create', as: :follow
	get '/unfollow', to: 'relationships#destroy', as: :unfollow
  # End Relationships

  # Begin Subtopics
  resources :subtopics, only: [:show, :new, :create]

  # End Subtopics

  # Begin Messages Controller
  resources :messages, only: [:create]
  # End Messages Controller

  # Begin Conversations 
  resources :conversations, only: [:show, :create]
  # End Conversations

  # Begin Users Controller
  resources :users, only: [:show, :edit, :update]
	get '/leaderboards', to: 'users#index', as: :leaderboards
	get '/leaderboard_filter', to: 'users#leaderboard_filter', as: :leaderboard_filter
  get '/autocomplete', to: 'users#autocomplete', as: :autocomplete
  get '/recently_solved_problems', to: 'users#recently_solved_problems', as: :recently_solved_problems
  patch '/update_profile_img', to: 'users#update_profile_image', as: :update_profile_image
	get '/edit_profile/:id', to: 'users#edit_profile', as: :edit_profile
	patch '/edit_profile/:id', to: 'users#update_profile', as: :update_profile
  # End Users Controller

  # Begin Problems Controller
  resources :problems, only: [:show, :create, :edit, :destroy, :update, :new]
  # End Problems Controller

  # Begin StaticPages Controller
  get '/landing', to: 'static_pages#landing_page', as: :landing_page
	get '/about', to: 'static_pages#about', as: :about
	get '/attributions', to: 'static_pages#attributions', as: :attributions
  get '/math-formatting', to: 'static_pages#math_formatting'
  # End StaticPages Controller

  # Begin Branches Controller
  get '/dashboard', to: 'branches#index', as: :dashboard
  resources :branches, only: [:show, :new, :create]
  get '/problems_filter', to: 'branches#problems_filter', as: :problems_filter
  # End Branches Controller

  # Begin Posts Controller
  resources :posts, only: [:edit, :create, :update, :destroy]
  # End Posts Controller

  # Begin Comments Controller
  post '/comments', to: 'comments#create', as: :comments
	delete '/comments', to: 'comments#destroy', as: :destroy_comment
	get '/get_comments', to: 'comments#get_comments', as: :get_comments
	get '/comments/:id/edit', to: 'comments#edit', as: :edit_comment
	patch '/comments/:id', to: 'comments#update', as: :comment

  # End Comments Controller

  

	################################ NOTIFICATIONS #############################
	get '/read_notifications', to: 'notifications#read_notifications', 
																						as: :read_notifications

	# script tags
	mathjax 'mathjax'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
