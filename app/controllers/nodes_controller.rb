class NodesController < ApplicationController	
	before_filter :initialize_cses
	
	def index
		@selected_node = Node.desc(:weight).limit(1).first
		@posts = @selected_node.get_posts(params[:post_type]).page(params[:page])
		@tags = @selected_node.tags.desc(:created_at)
		
		respond_to do |format|
			format.html { render 'layout' }
		end
	end

	def show
		@selected_node = Node.find_by(keyname: params[:id])
		@selected_node.browse_count += 1
		@selected_node.update
		@posts = @selected_node.get_posts(params[:post_type]).page(params[:page])
		@tags = @selected_node.tags.desc(:created_at)

		respond_to do |format|
			format.html { render 'layout' }
		end
	end

	private
		def current_node_topics
			@topics = @selected_node.topics
		end
end
