class Reply
	include Mongoid::Document
	include Mongoid::Timpstamps

	embedded_in :topic, inverse_of: :replies
	belongs_to :user, inverse_of: :replies
end