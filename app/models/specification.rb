class Specification
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, type: String, localize: true
	field :description, type: String, localize: true

	# validations
	validates :title, presence: true
	validates :description, presence: true

	embedded_in :custom_search_engine
end