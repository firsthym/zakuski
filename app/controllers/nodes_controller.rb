class NodesController < ApplicationController	
	before_filter :initialize_cses
	before_filter :current_node_tags
	
	def index
		begin
			@selected_node = Node.desc(:weight).limit(1).first

			respond_to do |format|
				format.html { render 'layout' }
			end
		rescue
			respond_to do |format|
				flash[:error] = I18n.t('human.errors.no_records')
				redirect_to root_path
			end
		end
	end

	def show
		begin
			@selected_node = Node.find_by(title: params[:id])
			@selected_node.browse_count += 1
			@selected_node.update

			if params[:post_type] == 'cses'
			elsif params[:post_type] == 'topics'
			end
				
			respond_to do |format|
				format.html { render 'layout' }
			end
		rescue
			respond_to do |format|
				flash[:error] = I18n.t('human.errors.no_records')
				redirect_to root_path
			end
		end
	end

	private
		def current_node_tags
		  @tags = @selected_node.tags.desc(:created_at)
		end

		def current_node_topics
			@topics = @selected_node.topics
		end
end
