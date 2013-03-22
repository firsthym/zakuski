class Tag
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String, localize: true
	field :browse_count, type: Integer, default: 0
	field :keyname, type: String
	validates :name, presence: true

	has_and_belongs_to_many :posts
	belongs_to :node

	#index
	index({keyname: 1}, {unique: true, name: 'tag_keyname'})

	# change id to name
	def to_param
		keyname
	end
end
