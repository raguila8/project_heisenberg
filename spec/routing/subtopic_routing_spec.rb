require 'rails_helper'

RSpec.describe 'subtopic routing', :aggregate_failures, type: :routing do
  it "routes subtopics" do
    expect(get: "/subtopics/1").to route_to(
      controller: "subtopics", action: "show", id: "1")

    expect(post: "/subtopics").to route_to(
      controller: "subtopics", action: "create")

    expect(get: "/subtopics/new").to route_to(
      controller: "subtopics", action: "new")
  end
end
