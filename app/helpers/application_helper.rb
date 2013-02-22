module ApplicationHelper
	def current_user?(user)
		current_user == user
	end

	def correct_user!(user)
		unless current_user?(user)
			flash[:error] = I18n.t('human.errors.no_privilege')
			redirect_to nodes_path
		end
	end

	def store_location
		session[:return_to] = request.url
	end

	def redirect_back_or(default)
		redirect_to (session[:return_to] || default)
		session.delete(:return_to)
	end

	def get_node_link(node, selected_node)
		if params[:post_type] == 'cses'
			path = posts_node_path(node)
		elsif params[:post_type] == 'topics'
			path = posts_node_path(node, post_type: 'topics')
		end
		link_to "#{node.title}", path, 
			class: node == selected_node ? 'btn btn-info' : 'btn'
	end

	def get_tag_link(tag, selected_node, selected_tag)
		if params[:post_type] == 'cses'
			path = posts_node_tag_path(selected_node, tag)
		elsif params[:post_type] == 'topics'
			path = posts_node_tag_path(selected_node, tag, post_type: 'topics')
		end
		link_to tag.name, path, 
				class: tag == selected_tag ? 'label label-info' : 'label'
	end

	def get_posts_count_text(posts)
		if params[:post_type] == 'cses'
			t('human.text.how_many_cses', 
				count: posts.count).html_safe
		elsif params[:post_type] == 'topics'
			t('human.text.how_many_topics', 
				count: posts.count).html_safe
		end
	end

end
