class NodesController < ApplicationController	
	def index
		@selected_node = RealNode.first
		@custom_search_engines = @selected_node.custom_search_engines
		@topics = @selected_node.topics
		render 'layout'
	end

	def show
		@selected_node = RealNode.find(params[:id])
		@custom_search_engines = @selected_node.custom_search_engines
		@topics = @selected_node.topics
		render 'layout'
	end
end
