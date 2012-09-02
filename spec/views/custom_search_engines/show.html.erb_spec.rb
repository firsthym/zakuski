require 'spec_helper'

describe "custom_search_engines/show" do
  before(:each) do
    @custom_search_engine = assign(:custom_search_engine, stub_model(CustomSearchEngine))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
