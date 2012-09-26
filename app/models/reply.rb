class Reply
	include Mongoid::Document
  	include Mongoid::Timestamps

	belongs_to :topic, inverse_of: :replies
	belongs_to :custom_search_engine, inverse_of: :replies
	belongs_to :user, inverse_of: :replies
end