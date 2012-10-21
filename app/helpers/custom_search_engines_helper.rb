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
end
