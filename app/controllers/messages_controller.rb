class MessagesController < ApplicationController
	before_action :logged_in_user, only: [:create]

	def create

		@message = Message.new(message_params)
		@message.user_id = current_user.id
		if @message.save
		
		end
	end

	private

	def message_params
		params.require(:message).permit(:body, :conversation_id)
	end
end
