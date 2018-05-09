require 'rails_helper'

RSpec.describe 'branch routing', :aggregate_failures, type: :routing do
  it "routes branches" do
    expect(get: "/branches/1").to route_to(
      controller: "branches", action: "show", id: "1")

    expect(post: "/branches").to route_to(
      controller: "branches", action: "create")

    expect(get: "/branches/new").to route_to(
      controller: "branches", action: "new")

    expect(get: "/dashboard").to route_to(
      controller: "branches", action: "index")

    expect(get: "/problems_filter").to route_to(
      controller: "branches", action: "problems_filter")
  end
end
