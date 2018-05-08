require "rails_helper"

RSpec.describe "users login" do
  let(:user) { FactoryBot.create(:user, name: "rodrigo") }

  def log_in_as(user)
    visit new_user_session_path
    fill_in("user_email", with: user.email)
    fill_in("user_password", with: user.password)
    click_button("Log in")
  end

  describe "login with invalid information" do
    it "should render the login page with an error message" do
      visit new_user_session_path
      expect(current_path).to eq(new_user_session_path)
      expect(page).not_to have_selector('#error_explanation')
      fill_in('user_email', with: '')
      fill_in('user_password', with: '')
      click_button('Log in')
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_selector('#error_explanation')
      within("#error_explanation") do
        expect(page).to have_selector("li", text: "Invalid Email or password")
      end
      visit root_path
      expect(page).not_to have_selector('#error_explanation')
    end
  end

  describe "login with valid information followed by logout", :js do
    it "should login with valid information" do
      visit new_user_session_path
      fill_in("user_email", with: user.email)
      fill_in("user_password", with: user.password)
      click_button("Log in")
      expect(current_path).to eq(root_path)
      expect(page).to have_selector(".dashboard-page")
      expect(page).to have_selector(".dropdown")
      find(".dropdown").click
      within(".dropdown") do
        click_on("Log out")
      end
      expect(current_path).to eq(root_path)
      expect(page).to have_selector("#home") 
    end
  end
end

