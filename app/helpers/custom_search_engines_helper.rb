module CustomSearchEnginesHelper
	def get_access_html(custom_search_engine)
		if custom_search_engine.access == 'public'
			title = I18n.t('human.text.public_what')
			link_to I18n.t('human.text.public'), 'javascript:void(0)', class: 'btn btn-success btn-mini-new', title: title
		elsif custom_search_engine.access == 'protected'			
			title = I18n.t('human.text.protected_what')
			link_to I18n.t('human.text.protected'), 'javascript:void(0)', class: 'btn btn-warning btn-mini-new', title: title
		end
	end

	def get_link_count_html(custom_search_engine)
		title = I18n.t('human.text.annotations_count')
		link_to custom_search_engine.annotations.count, 'javascript:void(0)', class: 'btn btn-info btn-mini-new', title: title
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
			if cookies['keeped_cse_ids'].include?(custom_search_engine.id)
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
