class NodesController < ApplicationController	
	before_filter :initialize_cses
	before_filter :current_node_cses
    before_filter :current_node_tags
	before_filter :current_node_topics
	def index
		respond_to do |format|
			format.html { render 'layout' }
		end
	end

	def show
		respond_to do |format|
			format.html { render 'layout' }
		end
	end

	private
		def current_node_cses
			if(params[:id].present?)
				@selected_node = Node.find_by(title: params[:id])
                @selected_node.browse_count += 1
                @selected_node.update
			else
				@selected_node = Node.desc(:weight).limit(1).first
			end
			if @selected_node.present?
              @custom_search_engines = @selected_node.get_custom_search_engines.page(params[:page])
			else
			  redirect_to root_path
			end
		end

        def current_node_tags
          @tags = @selected_node.tags
        end

		def current_node_topics
			@topics = @selected_node.topics
		end
end
