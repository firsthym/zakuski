class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :set_locale

	def set_locale
		I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
	end

	def available_cses
      # the linked custom search engine
      if(cookies[:linked_cseid].nil?)
        @linked_cse = CustomSearchEngine.get_hot_cses.first
        cookies[:linked_cseid] = @linked_cse.id
      else
        @linked_cse = CustomSearchEngine.find(cookies[:linked_cseid])
      end

      # keeped custom search engines
      if user_signed_in?
        @keeped_custom_search_engines = current_user.keeped_custom_search_engines
      else
        if(cookies[:keeped_cse_ids].nil?)
          @keeped_custom_search_engines = CustomSearchEngine.get_hot_cses.limit(10)
          cookies[:keeped_cse_ids] = @keeped_custom_search_engines.map { |cse| cse.id }.join(',')
        else
          @keeped_custom_search_engines = cookies[:keeped_cse_ids].split(',').map{|cseid| CustomSearchEngine.find(cseid)}
        end
      end
    end
    
	private 
		def extract_locale_from_accept_language_header
			client_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}|[^a-z]{2}-[A-Z]{2}/).first
			client_locale if I18n.available_locales.include?(client_locale)
		end
end
