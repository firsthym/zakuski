class Specification
	include Mongoid::Document

	field :search_mode, type: String, default: 'boost'
	field :mode_weight, type: Integer, default: 1
	field :search_image, type: Boolean, default: false
	field :search_thumbnail, type: Boolean, default: true 
	field :sort_by, type: String, default: 'relevance'

	attr_accessible :search_mode, :search_image, :sort_by, :search_thumbnail

	# validations
	validates :search_mode, inclusion: { in: ['filter', 'boost'] }
	validates :sort_by, inclusion: { in: ['relevance', 'date'] }

	embedded_in :custom_search_engine
end