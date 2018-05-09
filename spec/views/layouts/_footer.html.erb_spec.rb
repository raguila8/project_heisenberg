require "rails_helper"

RSpec.describe "layouts/_footer.html.erb" do
  def should_have_right_links
    expect(rendered).to have_link('About')
    expect(rendered).to have_link('Attributions')
    expect(rendered).to have_link('Github')
    expect(rendered).to have_selector('.copyright')
  end

  context "logged in and not admin" do
    let(:user) { FactoryBot.create(:user) }

    it "should contain the right links" do
      sign_in user
      render
      should_have_right_links
    end
  end

  context "logged in admin" do
    let(:user) { FactoryBot.create(:user, admin: true) }

    it "should contain the right links" do
      sign_in user
      render
      should_have_right_links
    end
  end

  context "not logged in" do
    it "should contain the right links" do
      render
      should_have_right_links
    end
  end
end
