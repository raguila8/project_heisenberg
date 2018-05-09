require "rails_helper"

RSpec.describe "static_pages/landing_page" do
  describe "landing page buttons" do
    context "user that is not logged in" do
      describe "main banner button" do
        it "contains 'START NOW FREE'" do
          render
          within("#home") do
            expect(rendered).to have_selector("#btn-home")
            expect(find('#btn-home').value).to eq('START NOW FREE')
          end
        end

        it "links user to sign up page" do
          render
          within("#home") do
            expect(rendered).to have_selector(:css, "a[href='#{signup_path}']")
          end
        end
      end

      describe "call to action button" do
        it "contains Let's Get Started" do
          render
          within("#cta") do
            expect(rendered).to have_selector("#btn-cta")
            expect(find('#btn-cta').value).to eq("Let's Get Started")
          end
        end

        it "links user to sign up page" do
          render
          within("#cta") do
            expect(rendered).to have_selector(:css, "a[href='#{signup_path}']")
          end
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
          within("#home") do
            expect(rendered).to have_selector("#btn-home")
            expect(find('#btn-home').value).to eq('SOLVE NOW!')
          end
        end

        it "links user to dashboard" do
          render
          within("#home") do
            expect(rendered).to have_selector(:css, 
                                                "a[href='#{dashboard_path}']")
          end
        end
      end

      describe "call to action button" do
        it "contains 'Start Solving!'" do
          render
          within("#cta") do
            expect(rendered).to have_selector("#btn-cta")
            expect(find('#btn-cta').value).to eq("Start Solving!")
          end
        end

        it "links user to dashboard" do
          render
          within("#cta") do
            expect(rendered).to have_selector(:css, 
                                                "a[href='#{dashboard_path}']")
          end
        end
      end
    end
  end
end
