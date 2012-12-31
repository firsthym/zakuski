class Annotation
	include Mongoid::Document

	field :about, type: String	
	field :score, type: Integer, default: 1
	field :labels, type: Array
	
	attr_accessible :about, :score

	# validations
	validates :about, presence: true, format: { with: /\Ahttp(s)?:\/\/.*\z/ }, uniqueness: true
	validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, 
																	less_than: 11 }

	embedded_in :custom_search_engnine
end
