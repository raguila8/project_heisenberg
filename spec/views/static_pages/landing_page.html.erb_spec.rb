require "rails_helper"

RSpec.describe "static_pages/landing_page" do
  describe "landing page buttons" do
    context "user that is not logged in" do
      describe "main banner button" do
        it "contains 'START NOW FREE'" do
          render
          expect(rendered).to have_selector("#btn-home")
          expect(rendered).to have_xpath("//input[@value='START NOW FREE']")
        end

        it "links user to sign up page" do
          render
          expect(rendered).to have_selector(:css, 
                                        "#home form[action='#{signup_path}']")
        end
      end

      describe "call to action button" do
        it "contains Let's Get Started" do
          render
          expect(rendered).to have_selector("#btn-cta")
          expect(rendered).to have_xpath("//input[@value=\"Let's Get Started\"]")
        end

        it "links user to sign up page" do
          render
          expect(rendered).to have_selector(:css, 
                                        "#cta form[action='#{signup_path}']")
        end
      end
    end

    context "logged in user" do
      let(:user) { FactoryBot.create(:user) }
      before(:example) do
       sign_in(user)
      end

      describe "main banner button" do
        it "contains 'SOLVE NOW!'" do
          render
          expect(rendered).to have_selector("#btn-home")
          expect(rendered).to have_xpath("//input[@value=\"SOLVE NOW!\"]")
        end

        it "links user to dashboard" do
          render
          expect(rendered).to have_selector(:css, 
                                     "#home form[action='#{dashboard_path}']")
        end
      end

      describe "call to action button" do
        it "contains 'Start Solving!'" do
          render
          expect(rendered).to have_selector("#btn-cta")
          expect(rendered).to have_xpath("//input[@value=\"Start Solving!\"]")
        end

        it "links user to dashboard" do
          render
          expect(rendered).to have_selector(:css, 
                                     "#cta form[action='#{dashboard_path}']")

        end
      end
    end
  end
end
