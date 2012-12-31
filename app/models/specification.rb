class Specification
	include Mongoid::Document

	field :title, type: String
	field :description, type: String

	attr_accessible :title, :description

	# validations
	validates :title, presence: true, length: {maximum: 50, minimum: 5}
	validates :description, length: {minimum: 0, maximum: 1024}

	embedded_in :custom_search_engine
end
