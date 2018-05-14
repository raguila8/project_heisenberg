require 'rails_helper'

RSpec.describe "Comment controller authorization" do
  let(:my_post) { FactoryBot.create(:post) }
  let(:comment) { FactoryBot.create(:comment, post: my_post, 
                                              user: my_post.user) }
  let(:other_comment) { FactoryBot.create(:other_comment, post: comment.post) }

  context "signed in" do
    before (:example) do
      sign_in comment.user
    end

    it "should create a comment" do 
      comment
      comments_count_before = Comment.all.count
      post comments_path, params: { comment: { content: "new comment", 
                            user_id: comment.user.id, 
                            post_id: comment.post.id } }, xhr: true
      expect(response).to have_http_status(:success)
      expect(Comment.all.count).to eq(comments_count_before + 1)
    end

    it "should destroy comment" do
      delete destroy_comment_path(id: comment.id), xhr: true
      expect(Comment.where(id: comment.id)).to be_empty
    end

    it "should get edit" do
      get edit_comment_path(comment.id), xhr: true
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should update comment" do
      patch comment_path(comment.id),
              params: { comment: { content: "updated comment" }, 
                                commit: "Update" }, xhr: true
      comment.reload
      expect(comment.content).to eq("updated comment")
    end

    it "should get_comments" do
      get get_comments_path, params: { post_id: comment.post.id, page: 1 }, 
                             xhr: true
      expect(response).to have_http_status(:success)
    end

    it "should redirect edit when comment does not belong to user" do
      get edit_comment_path(other_comment.id), xhr: true
      expect(response).to redirect_to topic_path(comment.post.topic.id)
      expect(flash[:alert]).to match('Action not authorized')
    end

    it "should redirect update when comment does not belong to user" do
      old_content = other_comment.content
      patch comment_path(other_comment.id),
                        params: { comment: { content: "updated comment" },
                                   commit: "Update" }, xhr: true
      expect(response).to redirect_to topic_path(comment.post.topic.id)
      expect(flash[:alert]).to match('Action not authorized')
      other_comment.reload
      expect(other_comment.content).to eq(old_content)
    end

    it "should redirect destroy when comment does not belong tpo user" do
      delete destroy_comment_path(id: other_comment.id), xhr: true
      expect(response).to redirect_to topic_path(comment.post.topic.id)
      expect(flash[:alert]).to match('Action not authorized')
      expect(Comment.where(id: other_comment.id)).not_to be_empty
    end
  end

  context "not signed in" do
    it "should redirect create" do
      comment
      comments_count_before = Comment.all.count
      post comments_path, params: { comment: { content: "new comment", 
                            user_id: comment.user.id, 
                            post_id: comment.post.id } }, xhr: true
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")

      expect(Comment.all.count).to eq(comments_count_before)
    end

    it "should redirect destroy" do
      delete destroy_comment_path(id: comment.id), xhr: true
      expect(Comment.where(id: comment.id)).to exist
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect edit" do
      get edit_comment_path(comment.id), xhr: true
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect update" do
      old_content = comment.content
      patch comment_path(comment.id),
                        params: { comment: { content: "updated comment" },
                                   commit: "Update" }, xhr: true

      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      expect(comment.content).to eq(old_content)
    end

    it "should redirect get_comments" do
      get get_comments_path, params: { post_id: comment.post.id, page: 1 }, 
                             xhr: true
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end
  end
end
