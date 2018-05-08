require "rails_helper"

RSpec.describe "users signup" do
  let(:user) { FactoryBot.create(:user, name: "rodrigo") }

  def user_signup(params)
    fill_in('user_username', with: params[:username])
    fill_in('user_email', with: params[:email])
    fill_in('user_password', with: params[:password])
    fill_in('user_password_confirmation', with: params[:password])
  end
  
  describe "signup with invalid information" do
    it "should render the signup page with an error message" do
      visit signup_path
      expect(current_path).to eq(signup_path)
      user_signup username: '', email: '', password: ''
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      visit root_path
      expect(page).not_to have_selector('#error_explanation')
    end

    it "should have the proper message when email is blank" do
      visit signup_path
      user_signup username: 'foobar11', email: '', password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", text: "Email can't be blank")
      end
    end

    it "should have the proper message when email is invalid" do
      visit signup_path
      user_signup username: 'foobar11', email: 'hello..com', password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", text: "Email is invalid")
      end
    end

    it "should have the proper message when username is blank" do
      visit signup_path
      user_signup username: '', email: 'hello@gmail.com', password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", text: "Username can't be blank")
      end
    end

    it "should have the proper message when username is too short" do
      visit signup_path
      user_signup username: 'foo', email: 'hello@gmail.com', password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
          text: "Username is too short (minimum is 5 characters)")
      end
    end

    it "should have the proper message when username is already taken" do
      visit signup_path
      user_signup username: user.username, email: 'hello@gmail.com', 
                                                            password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
                                      text: "Username has already been taken")
      end
    end

    it "should have the proper message when email is already taken" do
      visit signup_path
      user_signup username: 'foobar11', email: user.email, password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
                                      text: "Email has already been taken")
      end
    end

    it "should have the proper message when password is too short" do
      visit signup_path
      user_signup username: 'foobar11', email: 'hello@gmail.com', 
                                                          password: 'foo'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
                      text: "Password is too short (minimum is 6 characters)")
      end
    end

    it "should have the proper message when password is too long" do
      visit signup_path
      user_signup username: 'foobar11', email: 'hello@gmail.com', 
                                                          password: "a" * 130
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
                      text: "Password is too long")
      end
    end

    it "should have the proper message when username is too long" do
      visit signup_path
      user_signup username: "a" * 19, email: 'hello@gmail.com', 
                                                          password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
                      text: "Username is too long")
      end
    end

    it "should have the proper message when email is too long" do
      visit signup_path
      user_signup username: 'foobar11', email: "a" * 247 + "@gmail.com", 
                                                          password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(user_registration_path)
      expect(page).to have_selector('#error_explanation')
      within('#error_explanation') do
        expect(page).to have_selector("li", 
                      text: "Email is too long")
      end
    end
  end

  describe "signup with valid information" do
    it "should signup successfully and route to dashboard" do
      visit signup_path
      user_signup username: 'new_user', email: "foobar11@gmail.com", 
                                                      password: 'foobar'
      click_button('Sign up')
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_selector(".dashboard-page")
      expect(page).to have_selector("span", text: "new_user")
      expect(page).not_to have_selector('#error_explanation')
    end
  end
end
