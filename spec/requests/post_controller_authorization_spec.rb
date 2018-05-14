require 'rails_helper'

RSpec.describe "Post controller authorization" do
  #let(:user) { FactoryBot.create(:user, name: 'rodrigo') }
  let(:my_post) { FactoryBot.create(:post) }
  let(:other_post) { FactoryBot.create(:other_post, topic: my_post.topic) }

  context "signed in" do
    before(:example) do
      sign_in my_post.user
    end

    it "should get edit" do
      get edit_post_path(my_post.id), xhr: true
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should update" do
      patch post_path(my_post.id), 
              params: { post: { content: "updated post" }, 
                                commit: "Update" }, xhr: true
      my_post.reload
      expect(my_post.content).to eq("updated post")
    end

    it "should destroy" do
      delete post_path(my_post.id), xhr: true
      expect(Post.where(id: my_post.id)).to be_empty

    end

    it "should redirect edit when post does not belong to user" do
      get edit_post_path(other_post.id)
      expect(response).to redirect_to topic_path(my_post.topic.id)
      expect(flash[:alert]).to match('Action not authorized')
    end

    it "should redirect update when post does not belong to user" do
      old_content = other_post.content
      patch post_path(other_post.id), 
              params: { post: { content: "updated post" } }
      expect(response).to redirect_to topic_path(my_post.topic.id)
      expect(flash[:alert]).to match('Action not authorized')
      other_post.reload
      expect(other_post.content).to eq(old_content)
    end

    it "should redirect destroy when post does not belong to user" do
      delete post_path(other_post.id)
      expect(response).to redirect_to topic_path(my_post.topic.id)
      expect(flash[:alert]).to match('Action not authorized')
    end
  end

  context "not signed in" do
    it "should redirect edit" do
      get edit_post_path(my_post.id)
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect create" do
      post posts_path, params: { post: { content: "gibberish" } }
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect update" do
      old_content = my_post.content
      patch post_path(my_post.id), 
              params: { post: { content: "updated post" } }
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      my_post.reload
      expect(my_post.content).to eq(old_content)
    end

    it "should redirect destroy" do
      delete post_path(my_post.id)
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      expect(Post.where(id: my_post.id)).to exist
    end
  end
end
