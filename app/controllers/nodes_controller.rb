class NodesController < ApplicationController	
	
	def index
		@node = Node.desc(:weight).limit(1).first
		@posts = @node.get_posts(params[:post_type]).page(params[:page])
		@tags = @node.tags.desc(:created_at)
		
		respond_to do |format|
			format.html { render 'layout' }
		end
	end

	def show
		@node = Node.find_by(keyname: params[:id])
		@node.browse_count += 1
		@node.update
		@posts = @node.get_posts(params[:post_type]).page(params[:page])
		@tags = @node.tags.desc(:created_at)

		respond_to do |format|
			format.html { render 'layout' }
		end
	end

	private
		def current_node_topics
			@topics = @node.topics
		end
end
