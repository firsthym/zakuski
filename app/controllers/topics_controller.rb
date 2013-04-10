class TopicsController < PostsController
	before_filter :remove_empty_tags, only: [:create, :update]

	def create
		@post = Post.new(params[:post])
		@post.author = current_user
		@post.thumbnail = File.open(params[:thumbnail_url]) if params[:thumbnail_url].present?

		respond_to do |format|
			if @post.save
				format.js
				format.html { redirect_to topic_path(@post)}
			else
				format.js { @error = true}
			end
		end
	end

	def update
	end

	def append
	end

	def remove_empty_tags
		params[:topic][:tag_ids].delete_if { |t| t.blank? }
	end
end