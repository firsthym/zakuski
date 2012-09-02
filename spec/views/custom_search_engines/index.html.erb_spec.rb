require 'spec_helper'

describe "custom_search_engines/index" do
  before(:each) do
    assign(:custom_search_engines, [
      stub_model(CustomSearchEngine),
      stub_model(CustomSearchEngine)
    ])
  end

  it "renders a list of custom_search_engines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
