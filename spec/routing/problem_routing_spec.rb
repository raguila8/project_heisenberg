require 'rails_helper'

RSpec.describe 'problem routing', :aggregate_failures, type: :routing do
  it "routes problems" do
    expect(get: "/problems/1").to route_to(
      controller: "problems", action: "show", id: "1")

    expect(get: "/problems/1/edit").to route_to(
      controller: "problems", action: "edit", id: "1")

    expect(post: "/problems").to route_to(
      controller: "problems", action: "create")

    expect(get: "/problems/new").to route_to(
      controller: "problems", action: "new")

    expect(patch: "/problems/1").to route_to(
      controller: "problems", action: "update", id: "1")

    expect(delete: "/problems/1").to route_to(
      controller: "problems", action: "destroy", id: "1")
  end
end
