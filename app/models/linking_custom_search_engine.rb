class LinkingCustomSearchEngine
	include Mongoid::Document
	include Mongoid::Timestamps

	has_one :custom_search_engine

	belongs_to :user

end