class TagsController < ApplicationController
	before_filter :initialize_cses
	def show
		@selected_node = Node.find_by(title: params[:node_id])
		@tags = @selected_node.tags.desc(:created_at)
		@tag = Tag.find_by(name: params[:id])
		@tag.browse_count += 1
		@tag.update
		@posts = @tag.posts.post_type(params[:post_type]).recent.publish.page(params[:page])

		respond_to do |format|
			format.html { render 'nodes/layout'}
		end
	end
end
