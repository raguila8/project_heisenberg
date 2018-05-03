require "rails_helper"

RSpec.describe Problem do
  let (:problem) { FactoryBot.build_stubbed(:problem) }

  describe "difficulty" do
    it "should not be nil" do
      problem.difficulty = nil
      expect(problem.valid?).not_to be_truthy
      problem.difficulty = 1
      expect(problem.valid?).to be_truthy
    end

    it "should be either 1, 2 or 3" do
      valid_difficulties = [1, 2, 3]
      invalid_difficulties = [-1, 0, 4, 10]
      valid_difficulties.each do |n|
        problem.difficulty = n
        expect(problem.valid?).to be_truthy
      end

      invalid_difficulties.each do |n|
        problem.difficulty = n
        expect(problem.valid?).not_to be_truthy
      end
    end

    it "should not be a floating point" do
      invalid_floats = [1.1, 1.5, 2.5, 1.99]
      invalid_floats.each do |n|
        problem.difficulty = n
        expect(problem.valid?).not_to be_truthy
      end
    end
  end

  describe "title" do

    it "should not be nil" do
      problem.title = nil
      expect(problem.valid?).not_to be_truthy
      problem.title = "Addition"
      expect(problem.valid?).to be_truthy
    end

    it "should not be empty" do
      problem.title = ""
      expect(problem.valid?).not_to be_truthy
    end

    it "should be unique" do
      FactoryBot.create(:problem, title: "Addition")
      problem.title = "Addition"
      expect(problem.valid?).not_to be_truthy
      problem.title = "ADDITION"              # case insensitive
      expect(problem.valid?).not_to be_truthy
      problem.title = "Addition 2"
      expect(problem.valid?).to be_truthy
    end
  end

  describe "answer" do
    it "should not be nil" do
      problem.answer = nil
      expect(problem.valid?).not_to be_truthy
      problem.answer = 0
      expect(problem.valid?).to be_truthy
    end

    it "should be numerical" do
      problem.answer = ""
      expect(problem.valid?).not_to be_truthy
      problem.answer = "one"
      expect(problem.valid?).not_to be_truthy
      problem.answer = "1"
      expect(problem.valid?).to be_truthy
      problem.answer = "-2.11"
      expect(problem.valid?).to be_truthy
      problem.answer = 01
      expect(problem.valid?).to be_truthy
      problem.answer = 100
      expect(problem.valid?).to be_truthy
      problem.answer = 11e10
      expect(problem.valid?).to be_truthy
      problem.answer = -11.22
      expect(problem.valid?).to be_truthy
    end
  end

  describe "question" do
    it "should not be nil" do
      problem.question = nil
      expect(problem.valid?).not_to be_truthy
      problem.question = ""
      expect(problem.valid?).not_to be_truthy
      problem.question = "What is 1 + 1?"
      expect(problem.valid?).to be_truthy
    end
  end
end
