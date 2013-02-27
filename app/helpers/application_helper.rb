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

	def get_tag_link(tag, selected_node = nil, selected_tag = nil)
		if params[:post_type] == 'topics'
			path = posts_node_tag_path(tag.node, tag, post_type: 'topics')
		else
			path = posts_node_tag_path(tag.node, tag)
		end
		if selected_tag.present?
			link_to tag.name, path, 
				class: tag == selected_tag ? 'label label-info' : 'label'
		elsif selected_node.present?
			link_to tag.name, path, 
				class: selected_node.tags.include?(tag) ? 'label label-info' : 'label'
		else
			link_to tag.name, path, class: 'label'
		end
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

	def get_cses_tags(custom_search_engines)
		tags =[]
		custom_search_engines.each do |cse|
			tag_ids = []
			tag_ids = tags.map { |t| t.id } if tags.any?
			cse.tags.each { |t| tags.push t unless tag_ids.include?(t.id) }
		end
		html = "<ul class=\"inline\">"
		tags.each do |t|
			html += "<li>"
			html += link_to t.name, filter_tag_path(t), class: "label", remote: true, id: "tag-#{t.id}"
			html += "</li>"
		end
		html += "</ul>"
		html.html_safe
	end
end
