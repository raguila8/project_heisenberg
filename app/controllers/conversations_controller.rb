class ConversationsController < ApplicationController
	before_action :logged_in_user, only: [:create, :show]
	before_action :correct_conversation, only: [:show]

	def create
		sender = current_user
		recipient = User.find_by(username: params[:username])
		@conversation = Conversation.new
		# Need this to handle response
		@recipient_exists = true
		@new_conversation = true
		if recipient.nil?
			@recipient_exists = false
		else

			if Conversation.between(sender.id, recipient.id).present?
				@conversation = Conversation.between(sender.id, recipient.id).first
				@new_conversation = false
			else
				# creates new conversation if none exists
				@conversation = Conversation.create(sender_id: sender.id, recipient_id: recipient.id)
			end
			@message = Message.new(body: params[:body], user_id: sender.id, conversation_id: @conversation.id)
			@message.save
			# Update updated_at field
			@conversation.touch
		end

		#redirect_to conversation_path(@conversation.id)
	end

	def show
		@conversation = Conversation.find(params[:id])
		@messages = @conversation.messages.order(created_at: :asc)
		last_msg = @messages.last
		# Mark msg as read if msg is not yours and you are reading it for the 
		# first time
		if !last_msg.read && last_msg.user_id != current_user.id
			last_msg.read = true
			last_msg.save
		end
=begin
		@messages.each do |message|
			message.read = true
			message.save
		end
=end
		@message = Message.new
		@conversations = Conversation.where("sender_id = #{current_user.id} OR recipient_id = #{current_user.id}").order(updated_at: :desc)
	end

	def index
		@conversations = Conversation.where("sender_id = #{current_user.id} OR recipient_id = #{current_user.id}").order(updated_at: :desc)
	end

	def correct_conversation
		@conversation = Conversation.find(params[:id])
		redirect_to(root_url) unless (current_user.id == @conversation.sender_id || current_user.id == @conversation.recipient_id)
	end
end

