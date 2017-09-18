class TopicsController < ApplicationController
	before_action :logged_in_user, only: [:show]

	def show
		@thread = Topic.find(params[:id])
		@posts = @thread.posts.paginate(page: params[:page], :per_page => 15)
	end
end
