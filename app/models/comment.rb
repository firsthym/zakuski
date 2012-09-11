class Comment
	include Mongoid::Document
	include Mongoid::Timestamps
	
	field :body, type: String

	# validations
	validates :body, presence: true

	embedded_in :custom_search_engine
	belongs_to :user
end