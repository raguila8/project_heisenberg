require 'rails_helper'

RSpec.describe 'static_page routing', :aggregate_failures, type: :routing do
  it "routes static_pages" do
    expect(get: "/landing").to route_to(
      controller: "static_pages", action: "landing_page")

    expect(get: "/about").to route_to(
      controller: "static_pages", action: "about")

    expect(get: "/attributions").to route_to(
      controller: "static_pages", action: "attributions")

    expect(get: "/math-formatting").to route_to(
      controller: "static_pages", action: "math_formatting")
  end
end
