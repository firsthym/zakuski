module CustomSearchEnginesHelper
	def get_access_html(custom_search_engine)
		if custom_search_engine.access == 'public'
			title = I18n.t('human.text.public_what')
			content = I18n.t('human.text.public')
			style = 'badge-success'
		elsif custom_search_engine.access == 'protected'			
			title = I18n.t('human.text.protected_what')
			content = I18n.t('human.text.protected')
			style = 'badge-important'
		end
		content_tag :span, "#{content}", class: "badge #{style}", title: title
	end

	def get_link_count_html(custom_search_engine)
		title = I18n.t('human.text.annotations_count')
		content = custom_search_engine.annotations.count
		content_tag :span, "#{content}", class: "badge badge-info", title: title
	end

	def get_linked_cse_info(custom_search_engine)

	end

	def get_keep_or_remove_html(custom_search_engine)
		if user_signed_in?
			if current_user == custom_search_engine.author
				return ""
			elsif custom_search_engine.get_consumers.include?(current_user)
				label = I18n.t('human.text.remove_current_cse')
				path = remove_cse_path(@custom_search_engine)
			else
				label = I18n.t('human.text.keep_current_cse')
				path = keep_cse_path(@custom_search_engine)
			end
		else
			if cookies[:keeped_cse_ids].split(',').include?(custom_search_engine.id.to_s)
				label = I18n.t('human.text.remove_current_cse')
				path = remove_cse_path(@custom_search_engine)
			else
				label = I18n.t('human.text.keep_current_cse')
				path = keep_cse_path(@custom_search_engine)
			end
		end
		id = 'cse-keep-btn'
		"<div class='row-fluid cse-grid'><div class='span6 offset3'>" + 
		link_to(label, path, confirm: I18n.t('human.text.are_u_sure'), 
			remote: true, class: 'btn btn-block', id: id) + 
		"</div></div>"
	end

	def get_avatar(user,size='normal')
		if size == 'small'
			width = '32px'
			height = '32px'
		elsif size == 'normal'
			width = '64px'
			height = '64px'
		elsif size == 'medium'
			width = '80px'
			height = '80px'
		elsif size == 'big'
			width = '120px'
			height = '120px'
		elsif size == 'large'
			width = '220px'
			height = '220px'
		end
			
		if user.avatar.present?
			avatar = user.avatar_url
		else
			avatar = 'default.jpeg'
		end
		link_to(image_tag(avatar, width: width, height: height), user_path(user))
	end

	def simple_text(text)
		simple_format(h(text).gsub(/@(\w+)/) { |name| link_to(name, user_path(id: name.delete('@'))) })
	end
end
