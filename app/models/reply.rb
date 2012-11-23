class Reply
	include Mongoid::Document
  	include Mongoid::Timestamps
  	paginates_per 30

  	field :body, type: String
  	field :index, type: Integer

	belongs_to :topic, inverse_of: :replies
	belongs_to :custom_search_engine, inverse_of: :replies
	belongs_to :user, inverse_of: :replies

	validates :body, presence: true, length: {maximum: 4096}
	validates :user_id, presence: true

	attr_accessible :body, :custom_search_engine_id

	before_save do |reply|
		if reply.custom_search_engine.present?
			reply.index = reply.custom_search_engine.replies.count + 1
		elsif reply.topic.present?
			reply.index = reply.topic.replies.count + 1
		end
	end
	# scope
	scope :recent, desc(:created_at)
	# Index
  	index({topic_id: 1}, {name: 'topic_id'})
  	index({custom_search_engine_id: 1}, {name: 'custom_search_engine_id'})
  	index({user_id: 1}, {name: 'user_id'})

end