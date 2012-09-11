class Vote
	include Mongoid::Document
	include Mongoid::Timestamps

	field :point, type: Integer
	
	attr_accessible :point

	validates :point, format: {with: /\A[1-10]\z/}

	has_one :user	
	embedded_in :custom_search_engine
end