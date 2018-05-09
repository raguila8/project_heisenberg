require "rails_helper"

RSpec.describe "layouts/_header.html.erb" do
    before do
      allow_message_expectations_on_nil
      allow(@conversations).to receive(:count).and_return 0
    end

  context "logged in and not admin" do
    let (:user) { FactoryBot.create(:user) }

    it "should have the right links when signed in" do
      sign_in user
      render
      expect(rendered).to have_selector('.navbar-brand img')
      expect(rendered).to have_link('Dashboard')
      expect(rendered).to have_link('Leaderboard')
      expect(rendered).to have_selector('.glyphicon-comment')
      expect(rendered).to have_selector('.glyphicon-bell')
      expect(rendered).to have_selector('.dropdown .glyphicon-user')
      expect(rendered).to have_selector('.dropdown-toggle span', text: user.username)
      expect(rendered).to have_link('Progress')
      expect(rendered).to have_link('Account')
      expect(rendered).to have_link('Log out')
      expect(rendered).to have_selector('.navbar-form #main-search')

      expect(rendered).not_to have_link('New Problem')
      expect(rendered).not_to have_link('Register')
      expect(rendered).not_to have_link('Log In')
    end
  end

  context "not logged in" do
    it "should have the right links" do
      render
      expect(rendered).to have_selector('.navbar-brand img')
      expect(rendered).to have_link('Dashboard')
      expect(rendered).to have_link('Leaderboard')
      expect(rendered).not_to have_selector('.glyphicon-comment')
      expect(rendered).not_to have_selector('.glyphicon-bell')
      expect(rendered).not_to have_selector('.dropdown .glyphicon-user')
      expect(rendered).not_to have_link('Progress')
      expect(rendered).not_to have_link('Account')
      expect(rendered).not_to have_link('Log out')
      expect(rendered).to have_selector('.navbar-form #main-search')

      expect(rendered).not_to have_link('New Problem')
      expect(rendered).to have_link('Register')
      expect(rendered).to have_link('Log In')
    end
  end

  context "logged in and admin" do
    let (:user) { FactoryBot.create(:user, admin: true) }

    it "should have the right links" do
      sign_in user
      render
      expect(rendered).to have_selector('.navbar-brand img')
      expect(rendered).to have_link('Dashboard')
      expect(rendered).to have_link('Leaderboard')
      expect(rendered).to have_selector('.glyphicon-comment')
      expect(rendered).to have_selector('.glyphicon-bell')
      expect(rendered).to have_selector('.dropdown .glyphicon-user')
      expect(rendered).to have_selector('.dropdown-toggle span', text: user.username)
      expect(rendered).to have_link('Progress')
      expect(rendered).to have_link('Account')
      expect(rendered).to have_link('Log out')
      expect(rendered).to have_selector('.navbar-form #main-search')

      expect(rendered).to have_link('New Problem')
      expect(rendered).not_to have_link('Register')
      expect(rendered).not_to have_link('Log In')

    end
  end
end
