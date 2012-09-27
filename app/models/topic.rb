class Topic
	include Mongoid::Document
	include Mongoid::Timestamps

	has_many :replies

	belongs_to :node
	belongs_to :user

	# index
	index({node_id: 1}, {name: 'topic_node_id'})
	index({user_id: 1}, {name: 'topic_user_id'})
end