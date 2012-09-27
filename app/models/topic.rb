class Topic
	include Mongoid::Document
	include Mongoid::Timestamps

	has_many :replies

	belongs_to :node
	belongs_to :user

end