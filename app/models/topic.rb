class Topic
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :real_node
	belongs_to :user

	embeds_many :replies
end