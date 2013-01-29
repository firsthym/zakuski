class NodesController < ApplicationController	
	before_filter :initialize_cses
	before_filter :current_nodes_cses
	before_filter :current_nodes_topics
	def index
		render 'layout'
	end

	def show
		render 'layout'
	end

	private
		def current_nodes_cses
			if(params[:id].present?)
				@selected_node = Node.find(params[:id])
			else
				@selected_node = Node.desc(:weight).limit(1).first
			end
            if params[:tag].present? && tag = Tag.find_by(name: params[:tag]) && tag.node == @selected_node
              @custom_search_engines = tag.custom_search_engines
            else
			  @custom_search_engines = @selected_node.custom_search_engines.recent.publish.limit(20).page(params[:page])
            end
		end

		def current_nodes_topics
			@topics = @selected_node.topics
		end
end
