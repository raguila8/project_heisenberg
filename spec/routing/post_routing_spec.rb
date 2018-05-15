require 'rails_helper'

RSpec.describe 'post routing', :aggregate_failures, type: :routing do
  it "routes posts" do
    expect(post: "/posts").to route_to(
      controller: "posts", action: "create")

    expect(get: "/posts/1/edit").to route_to(
      controller: "posts", action: "edit", id: "1")

    expect(patch: "/posts/1").to route_to(
      controller: "posts", action: "update", id: "1")

    expect(delete: "/posts/1").to route_to(
      controller: "posts", action: "destroy", id: "1")
    
  end
end
