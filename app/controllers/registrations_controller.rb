class RegistrationsController < Devise::RegistrationsController
include ApplicationHelper
  #before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
	before_action :configure_permitted_parameters, only: [:create]

	# inherit from devise controller
	def new
		super
	end

	# inherit form devise controller
	def create
		super
	end

	protected

		# Redirect to specific page after successful sign up
		def after_sign_up_path_for(resource)
    	dashboard_path
  	end

		def configure_permitted_parameters
			devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
		end

	private
		
		def user_params
			params.require(:user).permit(:username, :email, :password, :password_confirmation)
		end
end
