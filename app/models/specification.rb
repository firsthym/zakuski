class Specification
	include Mongoid::Document

	field :title, type: String
	field :description, type: String
    field :search_mode, type: String, default: 'filter'
    field :mode_weight, type: Integer, default: 10
    field :search_image, type: Boolean, default: false
    field :search_thumbnail, type: Boolean, default: true 
    field :sort_by, type: String, default: 'relevance'

	attr_accessible :title, :description, :search_mode,
                     :search_image, :sort_by, :search_thumbnail

	# validations
	validates :title, presence: true, length: { maximum: 50, minimum: 5 }
	validates :description, length: { minimum: 0, maximum: 1024 }
    validates :search_mode, inclusion: { in: ['filter', 'boost'] }
    validates :sort_by, inclusion: { in: ['relevance', 'date'] }

	embedded_in :custom_search_engine
end
