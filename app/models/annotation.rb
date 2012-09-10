class Annotation
	include Mongoid::Document
	include Mongoid::Timestamps

	field :about, type: String	
	field :mode, type: String
	
	# validations
	validates :about, presence: true, format: {with: /\Ahttp(s)?:\/\/.*\z/}
	validates :mode, presence: true, inclusion: {in: ['filter', 'exclude', 'boost']}

	embedded_in :custom_search_engnine
end