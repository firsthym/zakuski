class TagsController < ApplicationController
	def show
		@tag = Tag.find_by(keyname: params[:id])
		@selected_node = @tag.node
		@tags = @selected_node.tags.desc(:created_at)
		@tag.browse_count += 1
		@tag.update
		@posts = @tag.posts.post_type(params[:post_type]).recent.publish.page(params[:page])

		respond_to do |format|
			format.html { render 'nodes/layout'}
		end
	end

	def filter_by_tag
		begin
			@tag = Tag.find_by(keyname: params[:id])
			@cses = []
			@dashboard_cses.each do |cse|
				tag_ids = cse.tags.map { |t|  t.id }
				@cses.push cse if tag_ids.include? @tag.id
			end

			respond_to do |format|
				format.js
			end
		rescue
			@error = t('human.errors.general')
			respond_to do |format|
				format.js
			end
		end
	end

end
