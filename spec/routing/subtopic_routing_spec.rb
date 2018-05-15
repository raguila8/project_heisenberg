require 'rails_helper'

RSpec.describe 'subtopic routing', :aggregate_failures, type: :routing do
  it "routes subtopics" do
    expect(post: "/subtopics").to route_to(
      controller: "subtopics", action: "create")

    expect(get: "/subtopics/new").to route_to(
      controller: "subtopics", action: "new")
  end
end
