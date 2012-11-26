require 'spec_helper'
describe "CustomSearchEngines" do
    subject {page}
    describe "GET /nodes" do
    	before { visit nodes_path }
      it 'should have dashboard' do
       should have_selector('#dashboard-cse')
       #save_and_open_page
   	  end
    end

    describe 'GET /nodes' do
      before {visit nodes_path}
    	it 'is 2-columns layout' do
    		should have_selector 'div.span7'
    		should have_selector 'div.span3'
    	end
    end

    describe 'Create a new cse' do
      before do
        visit nodes_path
        find('#new_cse').click
      end
      describe 'without login' do
        it 'redirect to the root page with a alert flash' do 
          should have_selector '.alert.alert-alert'
        end
      end
      describe 'signin' do
        let(:user) {FactoryGirl.create(:user)}
        before do 
          visit signin_path
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: user.password
          click_button 'signin'
        end
        it 'should redirect to new_cse_path' do
          should have_content I18n.t('human.text.description_what')
        end
      end
    end
end