class Comment
	include Mongoid::Document
	include Mongoid::Timestamps
	
	field commenter, type: String
	field body, type: String

	belongs_to :custom_search_engine
	belongs_to :user
end