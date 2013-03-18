class Annotation
	include Mongoid::Document

	field :about, type: String
	field :score, type: Integer, default: 1
	field :label_ids, type: Array, default: []
	
	attr_accessible :about, :score, :labels

	# validations
	validates :about, format: { with: /\Ahttp(s)?:\/\/.*\z/ }, uniqueness: true
	validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, 
																																	less_than: 11 }
	embedded_in :custom_search_engine
	
	scope :score_desc,desc(:score)

	def labels=(label_ids)
		self.label_ids = label_ids.split(',').compact.map{ |id| id.strip }
	end
	
	def labels
		self.custom_search_engine.labels.where(:id.in => self.label_ids).map { |label| label.id }.join(',')
	end

	def labels_list
		self.custom_search_engine.labels.where(:id.in => self.label_ids).map { |label| label.name }
	end
end
