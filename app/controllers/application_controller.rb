class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :set_locale

	private
    def set_locale
  		I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
  	end

		def extract_locale_from_accept_language_header
			client_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}|[^a-z]{2}-[A-Z]{2}/).first
			client_locale if I18n.available_locales.include?(client_locale)
		end

    def available_cses
        # the linked custom search engine
        if(cookies[:linked_cseid].nil?)
          @linked_cse = CustomSearchEngine.get_default_cse
        else
          @linked_cse = CustomSearchEngine.find(cookies[:linked_cseid])
        end
        if @linked_cse.nil?
          cookies.delete(:linked_cseid)
        else
          cookies[:linked_cseid] = @linked_cse.id
        end

        # keeped custom search engines
        if user_signed_in?
          @keeped_custom_search_engines = current_user.keeped_custom_search_engines
          if(cookies[:keeped_cse_ids].present?)
            keeped_cse_ids = @keeped_custom_search_engines.map{|cse| cse.id}
            cses_from_cookie = CustomSearchEngine.in(id: cookies[:keeped_cse_ids].split(',').delete_if{|cseid| keeped_cse_ids.include?(cseid)}).compact
            @keeped_custom_search_engines.push(cses_from_cookie)
            current_user.keeped_custom_search_engines.push(cses_from_cookie)
            cookies.delete(:keeped_cse_ids)
          end
        else
          if(cookies[:keeped_cse_ids].blank?)
            @keeped_custom_search_engines = CustomSearchEngine.get_hot_cses.limit(5)
          else
            @keeped_custom_search_engines = cookies[:keeped_cse_ids].split(',').map{|cseid| CustomSearchEngine.find(cseid)}
            @keeped_custom_search_engines.compact!
            if @keeped_custom_search_engines.blank?
              @keeped_custom_search_engines = CustomSearchEngine.get_hot_cses.limit(5)
            end
          end
          if @keeped_custom_search_engines.blank?
            cookies.delete(:keeped_cse_ids)
          else
            cookies[:keeped_cse_ids] = @keeped_custom_search_engines.map{ |cse| cse.id }.join(',') 
          end
        end
    end
    
     def after_sign_out_path_for(resource_or_scope)
      signin_path
    end
end
