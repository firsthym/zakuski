class TopicsController < PostsController
	before_filter :remove_empty_tags, only: [:create, :update]

	def remove_empty_tags
		params[:topic][:tag_ids].delete_if { |t| t.blank? }
	end
end