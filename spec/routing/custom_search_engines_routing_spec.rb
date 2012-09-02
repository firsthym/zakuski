require "spec_helper"

describe CustomSearchEnginesController do
  describe "routing" do

    it "routes to #index" do
      get("/custom_search_engines").should route_to("custom_search_engines#index")
    end

    it "routes to #new" do
      get("/custom_search_engines/new").should route_to("custom_search_engines#new")
    end

    it "routes to #show" do
      get("/custom_search_engines/1").should route_to("custom_search_engines#show", :id => "1")
    end

    it "routes to #edit" do
      get("/custom_search_engines/1/edit").should route_to("custom_search_engines#edit", :id => "1")
    end

    it "routes to #create" do
      post("/custom_search_engines").should route_to("custom_search_engines#create")
    end

    it "routes to #update" do
      put("/custom_search_engines/1").should route_to("custom_search_engines#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/custom_search_engines/1").should route_to("custom_search_engines#destroy", :id => "1")
    end

  end
end
