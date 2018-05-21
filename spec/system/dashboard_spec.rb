require "rails_helper"

RSpec.describe "dashboard content" do
  let(:user) { FactoryBot.create(:user, name: "rodrigo") }
  let(:classical_mechanics_branch) { FactoryBot.create(:branch, 
                                       name: "Classical Mechanics") }
  let(:thermodynamics_branch) { FactoryBot.create(:branch, name: "Thermodynamics") }
  let(:thermodynamics_problem) { FactoryBot.create(:problem, 
                                   title: "Thermodynamics Problem") }
  let(:classical_mechanics_problem) { FactoryBot.create(:problem, 
                                   title: "Classical Mechanics Problem") }
  let(:heat_transfer_subtopic) { FactoryBot.create(:subtopic, 
                                name: "Heat Transfer", 
                                branch: thermodynamics_branch) }
  let(:momentum_subtopic) { FactoryBot.create(:subtopic, 
                                name: "Momentum", 
                                branch: classical_mechanics_branch) }
  before(:example) do
    ProblemCategory.create(problem_id: classical_mechanics_problem.id, 
      subtopic_id: momentum_subtopic.id)
    ProblemCategory.create(problem_id: thermodynamics_problem.id, 
      subtopic_id: heat_transfer_subtopic.id) 
  end


  describe "logged in user" do
    before(:example) do
      sign_in user
    end

    it "should have branch cards for each branch" do
      visit dashboard_path
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_selector(".branch-card", count: 2)
      expect(page).to have_content(classical_mechanics_branch.name)
      expect(page).to have_content(thermodynamics_branch.name)
      expect(page).to have_selector(:button, "Browse Problems", count: 2)
    end

    it "should have progress bars and problems solved information" do
      visit dashboard_path
      expect(page).to have_selector(".progress", count: 2)
      expect(page).to have_selector(".problems-solved", count: 2)
    end

    it "should accurately show the users progress for each branch" do
      visit dashboard_path
      expect(page).to have_content("0.0%", 2)
      SolvedProblem.create(user_id: user.id, 
                             problem_id: classical_mechanics_problem.id)
      visit dashboard_path
      expect(page).to have_content("0.0%", 1)
      expect(page).to have_content("100.0%", 1)
    end
  end

  describe "user not logged in" do

    it "should have branch cards for each branch" do
      visit dashboard_path
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_selector(".branch-card", count: 2)
      expect(page).to have_content(classical_mechanics_branch.name)
      expect(page).to have_content(thermodynamics_branch.name)
      expect(page).to have_selector(:button, "Browse Problems", count: 2)
    end

    it "should not have any user information" do
      visit dashboard_path
      expect(page).not_to have_selector(".progress")
      expect(page).not_to have_selector(".problems-solved")
    end
  end
end
