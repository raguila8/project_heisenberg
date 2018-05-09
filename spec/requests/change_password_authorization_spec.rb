require 'rails_helper'

RSpec.describe "change password requests" do
  let (:user) { FactoryBot.create(:user, name: 'rodrigo') }

  def change_password_params(new_password, old_password)
    { user: { password: new_password, password_confirmation: new_password, 
                                        current_password: old_password }}
  end

  context "user not logged in" do
 
    it "should redirect edit (change_password) when not logged in" do
      get "/change_password/#{user.id}"
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect update when not logged in" do
      old_password = user.password
      put(user_registration_path(id: user.id), 
                params: change_password_params("new_password", user.password))
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      expect(old_password).to eq(user.password)
    end
  end

  context "user signed in" do
    let(:other_user) { FactoryBot.create(:user, username: "other_user", 
                        email: "otheruser@gmail.com", password: "foobar",
                        name: "other user") }
    it "should redirect edit (change_password) when signed in as 
                                                              another user" do
      sign_in other_user
      get "/change_password/#{user.id}"
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Action not authorized")
    end

    it "should redirect update when signed in as another user" do
      sign_in other_user
      old_password = user.password
      put(user_registration_path(id: user.id), 
                params: change_password_params("new_password", user.password))
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match("Action not authorized")
      expect(old_password).to eq(user.password)
    end

    it "should successfully route to edit when signed in as correct user" do
      sign_in user
      get "/change_password/#{user.id}"
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should successfully update when signed in as correct user" do
      sign_in user
      old_password = user.encrypted_password
      put(user_registration_path(id: user.id), 
                params: change_password_params("new_password", user.password))
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be_nil
      user.reload
      expect(user.encrypted_password).not_to eq(old_password)
      expect(flash[:notice]).to match("Your account has been updated successfully.")
    end
  end
end
