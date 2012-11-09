module NotificationsHelper
	def count_html(count)
		if count == 0
			""
		elsif count > 99
			"(99+)"
		else
			"(#{count})" 
		end
	end
end
