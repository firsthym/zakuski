module ApplicationHelper
	def current_user?(user)
		current_user == user
	end

	def correct_user!(user)
		unless current_user?(user)
	        flash[:error] = I18n.t('human.errors.no_privilege')
	        redirect_to root_path
		end
	end
end
