class Annotation
	include Mongoid::Document

	field :about, type: String	
	field :mode, type: String
	
	attr_accessible :about, :mode

	# validations
	validates :about, presence: true, format: {with: /\Ahttp(s)?:\/\/.*\z/}, uniqueness: true
	validates :mode, presence: true, inclusion: {in: ['filter', 'exclude', 'boost']}

	embedded_in :custom_search_engnine
end