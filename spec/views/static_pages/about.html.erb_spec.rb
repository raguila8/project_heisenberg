require "rails_helper"

RSpec.describe "static_pages/about" do
  context "logged in" do
    let(:user) { FactoryBot.create(:user) }
    it "contains a 'Start Solving!' button in the CTA banner" do
      sign_in user
      render
      expect(rendered).to have_selector("#btn-cta")
      expect(rendered).to have_xpath("//input[@value='Start Solving!']")
      expect(rendered).to have_selector(:css, 
                                     "#cta form[action='#{dashboard_path}']")
    end
  end

  context "not logged in" do
    it "contains a Let's Get Started button in the CTA banner" do
      render
      expect(rendered).to have_selector("#btn-cta")
      expect(rendered).to have_xpath("//input[@value=\"Let's Get Started\"]")
      expect(rendered).to have_selector(:css, 
                                        "#cta form[action='#{signup_path}']")
    end
  end
end
