class ApplicationController < ActionController::Base
	before_filter :set_locale

	def set_locale
		I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
	end
	
	private 
	def extract_locale_from_accept_language_header
		client_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}|[^a-z]{2}-[A-Z]{2}/).first
		client_locale if I18n.available_locales.include?(client_locale)
	end

  protect_from_forgery
end
