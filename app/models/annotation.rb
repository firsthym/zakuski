class Annotation
	include Mongoid::Document

	field :about, type: String	
	#field :mode, type: String
	field :score, type: Integer, default: 1
	#field :facet, type: String
	field :label, type: String
	
	attr_accessible :about, :mode, :score, :facet

	# validations
	validates :about, presence: true, format: { with: /\Ahttp(s)?:\/\/.*\z/ }, uniqueness: true
	validates :mode, presence: true, inclusion: {in: ['filter', 'exclude', 'boost']}
	validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, 
																	less_than: 11 }
	validates :facet, length: { minimum: 0, maximum: 10}

	embedded_in :custom_search_engnine
end
