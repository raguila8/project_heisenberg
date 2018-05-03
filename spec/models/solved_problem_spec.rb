require "rails_helper"

RSpec.describe SolvedProblem do
  let (:solved_problem) { FactoryBot.build_stubbed(:solved_problem,  
                                               user: user, problem: problem) }
  let (:user) { FactoryBot.build_stubbed(:user) }
  let (:problem) { FactoryBot.build_stubbed(:problem) }

  it "should be valid for valid problem and user" do
    expect(solved_problem.valid?).to be_truthy
  end

  it "should have unique problem and user pairs" do
    expect(solved_problem.valid?).to be_truthy
    FactoryBot.create(:solved_problem, user: user, problem: problem)
    expect(solved_problem.valid?).not_to be_truthy
  end
end
