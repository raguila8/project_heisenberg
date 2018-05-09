require 'rails_helper'

RSpec.describe 'comment routing', :aggregate_failures, type: :routing do
  it "routes comments" do
    expect(post: "/comments").to route_to(
      controller: "comments", action: "create")

    expect(delete: "/comments").to route_to(
      controller: "comments", action: "destroy")

    expect(get: "/get_comments").to route_to(
      controller: "comments", action: "get_comments")

    expect(get: "/comments/1/edit").to route_to(
      controller: "comments", action: "edit", id: "1")

    expect(patch: "/comments/1").to route_to(
      controller: "comments", action: "update", id: "1") 
  end
end
