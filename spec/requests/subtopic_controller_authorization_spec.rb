require 'rails_helper'

RSpec.describe "Problem controller admin authorization" do
  let(:branch) { FactoryBot.create(:branch) }
  let(:subtopic) { FactoryBot.create(:subtopic, branch: branch) }
  let(:user) { FactoryBot.create(:user, admin: false) }
  let(:other_user) { FactoryBot.create(:other_user, admin: true) }

  context "signed in not admin" do
    before(:example) do
      sign_in user
    end

    it "should redirect new" do
      get new_subtopic_path
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
    end

    it "should redirect create" do
      subtopic
      expect(Subtopic.count).to eq(1)
      post subtopics_path, params: { subtopic: { name: "Energy", branch_id: branch.id } }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
      expect(Subtopic.count).to eq(1)
    end
  end

  context "signed in admin" do
    before(:example) do
      sign_in other_user
    end

    it "should get new" do
      get new_subtopic_path
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should create subtopic" do
      subtopic
      expect(Subtopic.count).to eq(1)
      post subtopics_path, params: { subtopic: { name: "Energy", branch_id: branch.id } }
      expect(response).to redirect_to branch_path(branch.id)
      expect(flash[:success]).to match("New subtopic created!")
      expect(Subtopic.count).to eq(2)
    end
  end

  context "not signed in" do
    it "should redirect new" do
      get new_subtopic_path
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should not create subtopic" do
      subtopic
      expect(Subtopic.count).to eq(1)
      post subtopics_path, params: { subtopic: { name: "Energy", branch_id: branch.id } }
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      expect(Subtopic.count).to eq(1)
    end
  end
end

