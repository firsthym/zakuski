class Topic < Post
	field :title, type: String
	validates :title, presence: true, length: { maximum: 50, minimum: 5 }
end