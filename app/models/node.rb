class Node
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, type: String, localize: true
	field :description, type: String, localize: true
	field :filter, type: String

	recursively_embeds_one

	has_many :custom_search_engines

	# index
	index({title: 1}, {name: 'node_title'})

	def cse_list
		if self.filter.nil?
			self.custom_search_engines
		else
			CustomSearchEngine.where(self.filter).count
		end
	end

end