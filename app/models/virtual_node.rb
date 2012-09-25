class VirtualNode < Node
	field :collector, type: String

	def custom_search_engines
		CustomSearchEngine.where(self.collector)
	end
end