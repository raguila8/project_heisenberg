class MessagesController < ApplicationController
	before_action :logged_in_user, only: [:create]

	def create
		if params[:commit] == "Preview Message"
			@message = Message.new(user_params)
			@message.conversation_id = params[:conversation_id]
			@message.user_id = current_user.id
			if @message.body.empty?
				@message.errors.add(:body, :blank, message: "can't be blank")
			end
			@conversation = Conversation.find(params[:conversation_id])
			@messages = @conversation.messages
			render 'conversations/show'
		elsif params[:commit] == "Post Message"
			@message = Message.new(user_params)
			@message.conversation_id = params[:conversation_id]
			@message.user_id = current_user.id
			@conversation = Conversation.find(params[:conversation_id])

			if @message.save
				@conversation.touch
				flash[:success] = "Message sent!"
				redirect_to conversation_path(params[:conversation_id])
			else
				@messages = @conversation.messages
				render 'conversations/show'
			end

		end
	end

	private

	def user_params
		params.require(:message).permit(:body)
	end
end
