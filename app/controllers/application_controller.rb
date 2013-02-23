class ApplicationController < ActionController::Base
	protect_from_forgery
		include ApplicationHelper

	before_filter :set_locale
		before_filter :unread_notifications_count

	private
		def set_locale
			I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
		end

		def extract_locale_from_accept_language_header
			if request.env['HTTP_ACCEPT_LANGUAGE'].present?
				client_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}|[^a-z]{2}-[A-Z]{2}/).first
				client_locale if I18n.available_locales.include?(client_locale)
			end
		end

		def initialize_cses
			# keeped/dashboard custom search engines
			@created_cses = []
			@keeped_cses = []
			@dashboard_cses = []
			if user_signed_in?
				# for members
				@created_cses = current_user.get_created_cses
				@keeped_cses = current_user.get_keeped_cses
				@dashboard_cses = current_user.get_dashboard_cses
				# clear cookies
				if(cookies[:keeped_cses].present?)
					cookies.delete(:keeped_cses)
				end
				if(cookies[:dashboard_cses].present?)
					cookies.delete(:dashboard_cses)
				end
			else
				# for guests, retrieve keeps and dashboard cses from cookies
				if(cookies[:keeped_cses].present?)
					@keeped_cses = CustomSearchEngine.get_from_cookie(cookies[:keeped_cses])
				end
				if @keeped_cses.present?
					cookies[:keeped_cses] = Marshal.dump(@keeped_cses) 
				else
					cookies.delete(:keeped_cses)
				end
				@keeped_cse_ids = @keeped_cses.map { |cse|  cse.id }

				if(cookies[:dashboard_cses].present?)
					@dashboard_cses = CustomSearchEngine.get_from_cookie(cookies[:dashboard_cses])
				end
				if @dashboard_cses.present?
					@dashboard_cses.each do |cse|
						if @keeped_cse_ids.blank?
							@dashboard_cses.clear
							break
						end
						unless @keeped_cse_ids.include? cse.id
							@dashboard_cses.delete(cse)
						end
					end
					if @dashboard_cses.any?
						cookies[:dashboard_cses] = Marshal.dump(@dashboard_cses)
					end
				end
			end
			@recommended_cses = CustomSearchEngine.get_hot_cses
			@recommended_cses = @recommended_cses - (@recommended_cses & @dashboard_cses)

			if @dashboard_cses.empty?
				if cookies[:has_visited].blank?
					@dashboard_cses = @recommended_cses
					cookies[:has_visited] = true
					cookies[:dashboard_cses] = Marshal.dump(@dashboard_cses)
					cookies[:keeped_cses] = Marshal.dump(@dashboard_cses)
				else
					cookies.delete(:dashboard_cses)
				end
			end

			# the linked custom search engine
			if(cookies[:linked_cseid].nil?)
				@linked_cse = @dashboard_cses.first
				@linked_cse = @recommended_cses.first if @linked_cse.nil?
			else
				@dashboard_cses.each do |cse|
					if cse.id.to_s == cookies[:linked_cseid]
						@linked_cse = cse 
						break
					end
				end
				if @linked_cse.nil?
					@recommended_cses.each do |cse|
						if cse.id.to_s == cookies[:linked_cseid]
							@linked_cse = cse 
							break
						end
					end
				end
			end
			if @linked_cse.present?
				cookies[:linked_cseid] = @linked_cse.id 
				@active_cse = @linked_cse
				cookies[:active_cseid] = @active_cse.id
			else
				cookies.delete(:linked_cseid)
			end
			@dashboard_cse_ids = @dashboard_cses.map{|cse| cse.id} if @dashboard_cse_ids.nil?
			@keeped_cse_ids = @keeped_cses.map{|cse| cse.id} if @keeped_cse_ids.nil?
			@created_cses_ids = @created_cses.map{|cse| cse.id} if @created_cses_ids.nil?
		end
		
		def after_sign_out_path_for(resource_or_scope)
			new_user_session_path
		end

		def unread_notifications_count
			if user_signed_in?
				@discus_count = current_user.notifications.all_unread('discus').count
				@cse_count = current_user.notifications.all_unread('cse').count
				@total_count = @discus_count + @cse_count
			end
		end

		def link_cse(custom_search_engine)
			cookies[:linked_cseid] = custom_search_engine.id
		end

		def keep_cse(custom_search_engine)
			if user_signed_in?
				current_user.push(:keeped_cses, {id: custom_search_engine.id, time: Time.now})
			else
				cookies[:keeped_cse_ids] += ",#{custom_search_engine.id}"
			end
		end

		def keep_and_link_cse(custom_search_engine)
			keep_cse(custom_search_engine)
			link_cse(custom_search_engine)
		end

		def add_cse_to_dashboard(custom_search_engine)
			if user_signed_in?
				if current_user.get_created_cses.include?(custom_search_engine) || current_user.get_keeped_cses.include?(custom_search_engine)
					# members get 10 slots at most
					if current_user.get_dashboard_cses.count <= 9
						current_user.push(:dashboard_cses, id: custom_search_engine.id)
					else
						false
					end
				else
					false
				end
			else
				# guests only get 5 slot at most
				if @keeped_cses.include?(custom_search_engine)
					if @dashboard_cses.count <= 4
						cookies[:dashboard_cses] = Marshal.dump(@dashboard_cses.push @custom_search_engine)
					else
						false
					end
				else
					false
				end
			end
		end

		def can_access?(cse)
			if cse.status == 'publish'
				true
			elsif user_signed_in? && (current_user == cse.author)
				true
			else
				false
			end
		end

end
