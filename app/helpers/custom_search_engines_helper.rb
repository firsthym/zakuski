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
end
