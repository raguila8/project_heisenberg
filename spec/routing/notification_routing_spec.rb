require 'rails_helper'

RSpec.describe 'notification routing', :aggregate_failures, type: :routing do
  it "routes notifications" do
    expect(get: "/read_notifications").to route_to(
      controller: "notifications", action: "read_notifications")
  end
end
