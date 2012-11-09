module ApplicationHelper
	def current_user?(user)
		current_user == user
	end

	def correct_user!(user)
		unless current_user?(user)
	        flash[:error] = I18n.t('human.errors.no_privilege')
	        redirect_to(:back)
		end
	end

	def store_location
		session[:return_to] = request.url
	end

	def redirect_back_or(default)
		redirect_to (session[:return_to] || default)
		session.delete(:return_to)
	end
end
