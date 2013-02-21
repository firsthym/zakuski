class NodesController < ApplicationController	
	before_filter :initialize_cses
	
	def index
		begin
			@selected_node = Node.desc(:weight).limit(1).first
			@posts = @selected_node.get_posts(true, params[:post_type])
			@tags = @selected_node.tags.desc(:created_at)
			
			respond_to do |format|
				format.html { render 'layout' }
			end
		rescue
			respond_to do |format|
				format.html do
					flash[:error] = I18n.t('human.errors.no_records')
					redirect_to root_path
				end
			end
		end
	end

	def show
		begin
			@selected_node = Node.find_by(title: params[:id])
			@selected_node.browse_count += 1
			@selected_node.update
			@posts = @selected_node.get_posts(true, params[:post_type])
			@tags = @selected_node.tags.desc(:created_at)

			respond_to do |format|
				format.html { render 'layout' }
			end
		rescue
			respond_to do |format|
				format.html do
					flash[:error] = I18n.t('human.errors.no_records')
					redirect_to root_path
				end
			end
		end
	end

	private
		def current_node_topics
			@topics = @selected_node.topics
		end
end
