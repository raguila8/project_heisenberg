require 'rails_helper'

RSpec.describe "Problem controller admin authorization" do
  let(:user) { FactoryBot.create(:user, admin: false) }
  let(:other_user) { FactoryBot.create(:other_user, admin: true) }
  let(:problem) { FactoryBot.create(:problem, title: "Addition") }
  let(:branch) { FactoryBot.create(:branch) }
  let(:subtopic) { FactoryBot.create(:subtopic, branch: branch) }

  context "signed in not admin" do
    before(:example) do
      sign_in user
    end

    it "should get show" do
      get problem_path(id: problem.id)
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect edit" do
      get edit_problem_path(problem.id)
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
    end

    it "should not update problem" do
      expect(problem.title).to eq("Addition")
      patch problem_path(id: problem.id), 
              params: { problem: { question: problem.question, 
                                   answer: problem.answer, 
                                   difficulty: problem.difficulty, 
                                   title: "Subtraction" }, 
                        subtopic: ["Momentum"] }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
      expect(problem.title).to eq("Addition")
    end

    it "should not destroy a problem" do
      problem
      expect(Problem.count).to eq(1)
      delete problem_path(id: problem.id)
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
      expect(Problem.count).to eq(1)

    end

    it "should redirect new" do
      get new_problem_path
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
    end

    it "should redirect create" do
      problem
      expect(Problem.count).to eq(1)
      post problems_path,
            params: { problem: { question: "What is 3 + 3?", 
                                 answer: 6, 
                                 difficulty: problem.difficulty, 
                                 title: "Subtraction" },
                      subtopic: ["Momentum"] }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to match("Action not authorized")
      expect(Problem.count).to eq(1) 
    end
  end

  context "signed in admin" do
    before(:example) do
      sign_in other_user
    end

    it "should get show" do
      get problem_path(id: problem.id)
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should get edit" do
      get edit_problem_path(problem.id)
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should update problem" do
      expect(problem.title).to eq("Addition")
      patch problem_path(id: problem.id), 
              params: { problem: { question: problem.question, 
                                   answer: problem.answer, 
                                   difficulty: problem.difficulty, 
                                   points: problem.points, 
                                   submissions: problem.submissions, 
                                   title: "Subtraction", 
                                   solved_by: problem.solved_by }, 
                        subtopic: [subtopic.id], 
                        problem_attribution: { update: "no" } }
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to dashboard_path
      problem.reload
      expect(problem.title).to eq("Subtraction")
    end

    it "should get new" do
      get new_problem_path
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should destroy problem" do
      problem
      expect(Problem.count).to eq(1)
      delete problem_path(id: problem.id)
      expect(flash[:success]).to match("Problem deleted")
      expect(Problem.count).to eq(0)
    end

    it "should create problem" do
      problem
      expect(Problem.count).to eq(1)
      post problems_path,
            params: { problem: { question: "What is 3 + 3?", 
                                 answer: 6, 
                                 difficulty: problem.difficulty, 
                                 title: "Subtraction" },
                      subtopic: [subtopic.id],
                      problem_attribution: { update: "no" } }
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to dashboard_path
      problem.reload
      expect(Problem.count).to eq(2)
    end
  end

  context "not signed in" do
    it "should get show" do
      get problem_path(id: problem.id)
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect edit" do
      get edit_problem_path(problem.id)
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should not update problem" do
      expect(problem.title).to eq("Addition")
      patch problem_path(id: problem.id), 
              params: { problem: { question: problem.question, 
                                   answer: problem.answer, 
                                   difficulty: problem.difficulty, 
                                   points: problem.points, 
                                   submissions: problem.submissions, 
                                   title: "Subtraction", 
                                   solved_by: problem.solved_by }, 
                        subtopic: [subtopic.id], 
                        problem_attribution: { update: "no" } }
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      problem.reload
      expect(problem.title).to eq("Addition")
    end

    it "should redirect new" do
      get new_problem_path
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should not destroy problem" do
      delete problem_path(id: problem.id)
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
    end

    it "should redirect create" do
      problem
      expect(Problem.count).to eq(1)
      post problems_path,
            params: { problem: { question: "What is 3 + 3?", 
                                 answer: 6, 
                                 difficulty: problem.difficulty, 
                                 title: "Subtraction" },
                      subtopic: ["Momentum"] }
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      expect(Problem.count).to eq(1)
    end
  end
end
