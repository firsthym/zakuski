require 'spec_helper'

describe "CustomSearchEngines" do
  describe "GET /custom_search_engines" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get custom_search_engines_path
      response.status.should be(200)
    end
  end
end
