FactoryGirl.define do
	factory :user do
		sequence(:username) {|n| 'Man#{n}'}
		sequence(:email) {|n| 'Man#{n}@example.com'}
		password '12345678'
		password_confirmation '12345678'
	end
end