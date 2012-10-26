require 'spec_helper'

describe "CustomSearchEngines" do
let(:request_env) { {'HTTP_ACCEPT_LANGUAGE' => 'zh-CN'} }

  describe "GET /cses" do
  	before { get cses_path, {}, request_env }

    it "should works" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      response.status.should be(200)
    end
    it 'should have dashboard' do
     response.body.should have_selector('li.nav-header.cse-small')
 	end
  end

  describe 'GET /nodes' do
  	before { get nodes_path, {}, request_env }

  	it 'should works' do 
  		response.status.should be(200)
  	end
  	it 'is 2-columns layout' do
  		response.body.should have_selector 'div.span7'
  		response.body.should have_selector 'div.span3'
  	end
  end

  describe 'Create a new cse' do
  	before { get new_cse_path, {}, request_env }
  	
  end
end