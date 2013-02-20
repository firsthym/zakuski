class Reply
	include Mongoid::Document
	include Mongoid::Timestamps
	paginates_per 50

	field :body, type: String
	field :index, type: Integer

	belongs_to :post, inverse_of: :replies
	belongs_to :user, inverse_of: :replies

	validates :body, presence: true, length: {maximum: 4096}
	validates :user_id, presence: true

	attr_accessible :body, :post_id

	before_save do |reply|
		if reply.post.present?
			reply.index = reply.post.replies.count + 1
		elsif reply.topic.present?
			reply.index = reply.topic.replies.count + 1
		end
	end
	# scope
	scope :recent, desc(:created_at)
	# Index
	index({post_id: 1}, {name: 'cse_post_id'})
	index({user_id: 1}, {name: 'user_id'})

end
