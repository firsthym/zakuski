class TopicsController < PostsController
	#before_filter :remove_empty_tags, only: [:create, :update]

	def new
		@post = Topic.new
	end

	def create
		@post = Topic.new(params[:topic])
		@post.author = current_user
		@post.status = 'draft'

		respond_to do |format|
			if @post.save
				ShadowWorker.perform_async(@post.id)
				format.js
				format.html { redirect_to @post}
			else
				@errors = @post.errors
				format.html do
					flash[:error] = @errors
					redirect_to root_path
				end
				format.js
			end
		end
	end

	def update
	end

	def append
	end

	def show
	end

	def remove_empty_tags
		params[:topic][:tag_ids].delete_if { |t| t.blank? }
	end
end