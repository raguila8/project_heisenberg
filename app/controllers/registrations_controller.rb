class RegistrationsController < Devise::RegistrationsController
include ApplicationHelper

	before_action :configure_permitted_parameters, only: [:create]

	# inherit from devise controller
	def new
		super
	end

	# inherit form devise controller
	def create
=begin
		@user = User.new(user_params)
		if @user.save
			sign_in(@user, scope: :user)
			flash[:success] = "Welcome to Project Heisenberg!"
			redirect_to dashboard_path
		else
			render 'new'
		end
=end
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
