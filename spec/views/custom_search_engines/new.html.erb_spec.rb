require 'spec_helper'

describe "custom_search_engines/new" do
  before(:each) do
    assign(:custom_search_engine, stub_model(CustomSearchEngine).as_new_record)
  end

  it "renders new custom_search_engine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => custom_search_engines_path, :method => "post" do
    end
  end
end
