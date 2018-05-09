require 'rails_helper'

RSpec.describe 'solved_problem routing', :aggregate_failures, type: :routing do
  it "routes solved_problems" do
    expect(post: "/attempt").to route_to(
      controller: "solved_problems", action: "create")
  end
end
