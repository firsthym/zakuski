require 'spec_helper'

describe "custom_search_engines/edit" do
  before(:each) do
    @custom_search_engine = assign(:custom_search_engine, stub_model(CustomSearchEngine))
  end

  it "renders the edit custom_search_engine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => custom_search_engines_path(@custom_search_engine), :method => "post" do
    end
  end
end
