require 'rails_helper'

RSpec.describe 'topic routing', :aggregate_failures, type: :routing do
  it "routes topics" do
    expect(get: "/topics/1").to route_to(
      controller: "topics", action: "show", id: "1")

    expect(put: "/like").to route_to(
      controller: "topics", action: "vote")
  end
end
