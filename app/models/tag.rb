class Tag
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :browse_count, type: Integer, default: 0
	validates :name, presence: true

	has_and_belongs_to_many :posts
	belongs_to :node

	# change id to name
	def to_param
		name
	end
end
