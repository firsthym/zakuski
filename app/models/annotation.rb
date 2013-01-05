class Annotation
	include Mongoid::Document

	field :about, type: String
	field :score, type: Integer, default: 1
	field :labels_list, type: Array, default: []
	
	attr_accessible :about, :score, :labels

	# validations
	validates :about, format: { with: /\Ahttp(s)?:\/\/.*\z/ }, uniqueness: true
	validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, 
																	less_than: 11 }
	embedded_in :custom_search_engine
	
	def labels=(labels)
		if labels.present?
			self.labels_list = labels.split(',') | self.custom_search_engine.labels.map do |l| 
				l.cse_destroy
			end
		end
	end
	
	def labels
		if labels_list.any?
			self.labels_list.join(',')
		else
			''
		end
	end
end
