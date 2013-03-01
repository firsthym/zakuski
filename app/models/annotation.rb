class Annotation
	include Mongoid::Document

	field :about, type: String
	field :score, type: Integer, default: 1
	field :labels_list, type: Array, default: []
	field :label_ids_array, type: Array, default: []
	
	attr_accessible :about, :score, :labels, :label_ids

	# validations
	validates :about, format: { with: /\Ahttp(s)?:\/\/.*\z/ }, uniqueness: true
	validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, 
																																	less_than: 11 }
	embedded_in :custom_search_engine
	
	scope :score_desc,desc(:score)
	def labels=(labels_str)
			if labels_str.present?
					self.labels_list = labels_str.split(',')
			end
	end
	
	def labels
			if labels_list.any?
					self.labels_list.join(',')
			else
					''
			end
	end

	def label_ids=(ids)
		self.label_ids_array = ids.reject { |id| id.blank? }
	end

	def label_ids
		self.label_ids_array
	end

	def get_valid_labels
		self.custom_search_engine.labels
	end

	def get_labels_group_by_mode
		ret = Array.new
		self.get_valid_labels.group_by { |l| l.mode }.each do |mode, labels|
			ret.push [ I18n.t("human.controls.select.#{mode}"), labels.map{ |l| [ l.name, l.id ]} ]
		end
		ret
	end

end
