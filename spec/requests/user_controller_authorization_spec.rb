require 'rails_helper'

RSpec.describe "User controller authorization" do
  let(:user) { FactoryBot.create(:user, name: 'rodrigo', 
                                occupation: "Developer", school: "UCLA", 
                                bio: "my bio...") }
  let(:other_user) { FactoryBot.create(:other_user, name: 'other user') }

  context "signed in" do
    before(:example) do
      sign_in user
    end

    it "it should get show when id=user.id" do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should get show when id!=user.id" do
      get "/users/#{other_user.id}"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should get edit when id=user.id" do
      get "/users/#{user.id}/edit"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect edit when id!=user.id" do
      get "/users/#{other_user.id}/edit"
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Action not authorized")
    end

    it "should update when signed in as right user" do
      put user_path(id: user.id), 
                              params: { user: { username: 'updated_username',
                                        email: 'updated_email@example.com' }}
      expect(response).to redirect_to user_path(user.id)
      expect(flash[:success]).to eq('Profile updated')
      user.reload
      expect(user.username).to match('updated_username')
      expect(user.email).to eq('updated_email@example.com')
    end

    it "should redirect update when signed in as another user" do
      old_username = other_user.username
      old_email = other_user.email
      put user_path(id: other_user.id), 
                               params: { user: { username: 'updated_username',
                                         email: 'updated_email@example.com' }}
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match('Action not authorized')
      other_user.reload
      expect(other_user.username).to eq(old_username)
      expect(other_user.email).to eq(old_email)
    end
=begin
    it "should redirect delete when signed in as another user" do
      delete "/"
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Action not authorized")
    end
=end

    it "should get index (leaderboards) successfully" do
      get "/leaderboards"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should get edit_profile when signed in as right user" do
      get "/edit_profile/#{user.id}"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect edit_profile when signed in as another user" do
      get "/edit_profile/#{other_user.id}"
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Action not authorized")
    end

    it "should update_profile when signed in as user" do
      new_name = "foobar"
      new_occupation = "work"
      new_school = "Hopkins"
      new_bio = "This is a sample bio."
      patch update_profile_path(id: user.id), params: { user: { name: new_name, 
                           occupation: new_occupation, school: new_school, 
                           bio: new_bio } }
      expect(response).to redirect_to(user_path(user.id))
      expect(flash[:success]).to eq('Profile updated')
      user.reload
      expect(new_name).to eq(user.name)
      expect(new_occupation).to eq(user.occupation)
      expect(new_school).to eq(user.school)
      expect(new_bio).to eq(user.bio)

    end

    it "should redirect update_profile when signed is as another user" do
      old_name = other_user.name
      old_occupation = other_user.occupation
      old_school = other_user.school
      old_bio = other_user.bio
      patch update_profile_path(id: other_user.id), 
                         params: { user: { name: "foobar", 
                           occupation: "work", school: "Hopkins", 
                           bio: "This is a sample bio." } }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Action not authorized")
      other_user.reload
      expect(old_name).to eq(other_user.name)
      expect(old_occupation).to eq(other_user.occupation)
      expect(old_school).to eq(other_user.school)
      expect(old_bio).to eq(other_user.bio)
    end

    it "should update_profile_image" do
      patch update_profile_image_path, 
        params: { user: { profile_image: 
                            Rack::Test::UploadedFile.new("spec/images/me.jpg",
                                                             "image/jpg") }}
      expect(response).to redirect_to user_path(user.id)
      expect(flash[:success]).to eq('Profile image updated')
    end
  end

  context "not signed in" do
    it "should get show" do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect edit when not signed in" do
      get "/users/#{user.id}/edit"
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should not update when not signed in" do
      old_username = user.username
      old_email = user.email
      put user_path(id: user.id), 
                               params: { user: { username: 'updated_username',
                                         email: 'updated_email@example.com' }}
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      user.reload
      expect(user.username).to eq(old_username)
      expect(user.email).to eq(old_email)
    end

    it "should get leaderboards" do
      get "/leaderboards"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect edit_profile" do
      get "/edit_profile/#{user.id}"
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect update_profile" do
      old_name = user.name
      old_occupation = user.occupation
      old_school = user.school
      old_bio = user.bio
      patch update_profile_path(id: user.id), params: { user: { name: "foobar", 
                           occupation: "work", school: "Hopkins", 
                           bio: "This is a sample bio." } }
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      user.reload
      expect(old_name).to eq(user.name)
      expect(old_occupation).to eq(user.occupation)
      expect(old_school).to eq(user.school)
      expect(old_bio).to eq(user.bio)
    end

    it "should redirect update_profile_image" do
      patch update_profile_image_path, 
        params: { user: { profile_image: 
                            Rack::Test::UploadedFile.new("spec/images/me.jpg",
                                                             "image/jpg") }}
        expect(response).to redirect_to(controller: "sessions", action: "new")
        expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end
  end
end
