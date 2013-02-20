class Post
	include Mongoid::Document
	include Mongoid::Timestamps
	paginates_per 50 	

	field :browse_count, type: Integer, default: 0

	has_many :replies, dependent: :delete
	has_and_belongs_to_many :tags

	belongs_to :author, class_name: 'User'
end