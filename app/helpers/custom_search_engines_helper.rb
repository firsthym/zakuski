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
			if custom_search_engine.consumers.include?(current_user)
				label = I18n.t('human.text.remove_current_cse')
				path = remove_cse_path(@custom_search_engine)
				id = 'cse-remove-btn'
			else
				label = I18n.t('human.text.keep_current_cse')
				path = keep_cse_path(@custom_search_engine)
				id = 'cse-keep-btn'
			end
		else
			if cookies['keeped_cse_ids'].split(',').include?(custom_search_engine.id.to_s)
				label = I18n.t('human.text.remove_current_cse')
				path = remove_cse_path(@custom_search_engine)
				id = 'cse-remove-btn'
			else
				label = I18n.t('human.text.keep_current_cse')
				path = keep_cse_path(@custom_search_engine)
				id = 'cse-keep-btn'
			end
		end
		link_to label, path, confirm: I18n.t('human.text.are_u_sure'), remote: true, class: 'btn btn-block', id: id
	end
end
