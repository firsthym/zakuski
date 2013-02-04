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
		content_tag :span, "#{content}", class: "badge badge-warning", title: title
	end

	def get_linked_cse_info(custom_search_engine)

	end

	def get_keep_or_remove_html(custom_search_engine)
		if user_signed_in?
			if current_user == custom_search_engine.author
				return ""
			elsif custom_search_engine.get_consumers.include?(current_user) && @keeped_cses.include?(custom_search_engine)
				label = I18n.t('human.text.remove_current_cse')
				path = remove_cse_path(@custom_search_engine)
			else
				label = I18n.t('human.text.keep_current_cse')
				path = keep_cse_path(@custom_search_engine)
			end
		else
			begin
				keeped_cses = Marshal.load(cookies[:keeped_cses])
				ids = keeped_cses.map { |cse| cse.id }
				if ids.include?(custom_search_engine.id)
					label = I18n.t('human.text.remove_current_cse')
					path = remove_cse_path(@custom_search_engine)
				else
					label = I18n.t('human.text.keep_current_cse')
					path = keep_cse_path(@custom_search_engine)
				end
			rescue
				cookies.delete(:keeped_cses)
				label = I18n.t('human.text.keep_current_cse')
				path = keep_cse_path(@custom_search_engine)
			end
		end
		id = 'cse-keep-btn'
		"<div class='row-fluid cse-grid'><div class='span6 offset3'>" + 
		link_to(label, path, confirm: I18n.t('human.text.are_u_sure'), 
			remote: true, class: 'btn btn-block btn-info', id: id) + 
		"</div></div>"
	end

	def get_avatar(user,version='normal')
		if user.avatar.present?
			avatar = user.avatar_url(version)
		else
			avatar = "#{version}_default.jpeg"
		end
		link_to(image_tag(avatar), user_path(user))
	end

	def simple_text(text)
		simple_format(h(text).gsub(/@(\w+)/) { |name| link_to(name, user_path(id: name.delete('@'))) })
	end
	
	def generate_themes_html(theme_obj, 
	themes = ['default', 'greensky', 'espresso', 'minimalist', 'shiny', 'bubblegum', 'classic'])
		html = '<ul class="thumbnails">'
		themes.each do |theme|
			choose_class = theme_obj.name == theme ? "cse-theme-choose" : ""
			html += "<li class=\"cse-theme-box\">
			<div class=\"thumbnail\ #{choose_class}\">
			<div class=\"cse-theme cse-theme-#{theme}\">
			<input type=\"hidden\" class=\"cse-theme-name\" value=\"#{theme}\" />
			</div>
			<h6 class=\"center\">#{t("human.text.theme.#{theme}")}</h6></div>
			</li>"
		end
		html += '</ul>'
		html.html_safe
	end
end
