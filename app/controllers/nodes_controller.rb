class NodesController < ApplicationController	
	def index
		@custom_search_engines = CustomSearchEngine.all
	end
end
