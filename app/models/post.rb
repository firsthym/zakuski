class Post
	include Mongoid::Document
	include Mongoid::Timestamps
	paginates_per 50 	

	field :title, type: String
	field :content, type: String
	field :browse_count, type: Integer, default: 0

	has_many :replies, dependent: :delete
	has_and_belongs_to_many :tags

	belongs_to :author, class_name: 'User'

	attr_accessible :tag_ids, :title, :content

	validates :title, presence: true, length: { maximum: 50, minimum: 5 }
	validates :content, length: { minimum: 0, maximum: 1024 }

end