class TagsController < ApplicationController
	before_filter :initialize_cses
	def show
		begin
			@selected_node = Node.find_by(title: params[:node_id])
			@tags = @selected_node.tags.desc(:created_at)
			@tag = Tag.find_by(name: params[:id])
			@tag.browse_count += 1
			@tag.update
			params[:post_type] = 'cses' if params[:post_type].blank?
			if params[:post_type] == 'cses'
				@custom_search_engines = @tag.posts.type('CustomSearchEngine').recent.publish.page(params[:page])
			elsif params[:post_type] == 'topics'
				@topics = @tag.posts.type('Topic').recent.publish.page(params[:page])
			end

			respond_to do |format|
				format.html { render 'nodes/layout'}
			end
		rescue
			respond_to do |format|
				flash[:error] = I18n.t('human.errors.no_records')
				format.html { render 'nodes/layout' }
			end
		end
	end
end
