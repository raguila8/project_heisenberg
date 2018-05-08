require "rails_helper"

RSpec.describe "landing page buttons" do
  context "user that is not logged in" do
    describe "main banner button" do
      it "contains 'START NOW FREE'" do
        visit landing_page_path
        within("#home") do
          expect(page).to have_selector("#btn-home")
          expect(find('#btn-home').value).to eq('START NOW FREE')
        end
      end

      it "links user to sign up page" do
        visit landing_page_path
        within("#home") do
          click_on("START NOW FREE")
        end
        expect(current_path).to eq(signup_path)
      end
    end

    describe "call to action button" do
      it "contains Let's Get Started" do
        visit landing_page_path
        within("#cta") do
          expect(page).to have_selector("#btn-cta")
          expect(find('#btn-cta').value).to eq("Let's Get Started")
        end
      end

      it "links user to sign up page" do
        visit landing_page_path
        within("#cta") do
          click_on("Let's Get Started")
        end
        expect(current_path).to eq(signup_path)
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
        visit landing_page_path
        within("#home") do
          expect(page).to have_selector("#btn-home")
          expect(find('#btn-home').value).to eq('SOLVE NOW!')
        end
      end

      it "links user to dashboard" do
        visit landing_page_path
        within("#home") do
          click_on("SOLVE NOW!")
        end
        expect(current_path).to eq(dashboard_path)
      end

    end

    describe "call to action button" do
      it "contains 'Start Solving!'" do
        visit landing_page_path
        within("#cta") do
          expect(page).to have_selector("#btn-cta")
          expect(find('#btn-cta').value).to eq("Start Solving!")
        end
      end

      it "links user to dashboard" do
        visit landing_page_path
        within("#cta") do
          click_on("Start Solving!")
        end
        expect(current_path).to eq(dashboard_path)
      end
    end
  end
end
