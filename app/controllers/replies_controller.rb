class RepliesController < ApplicationController
	def create
		@reply = Reply.new(params[:reply])
		@custom_search_engine = @reply.custom_search_engine
		@reply.user = current_user
		
		respond_to do |format|
			if @reply.save
				unless current_user == @custom_search_engine.author
					notification = Notification.new
					notification.user = @custom_search_engine.author
					notification.source = 'topic'
					notification.title = I18n.t('notification.new_reply', 
						{user: view_context.link_to(current_user.username, 
							user_path(current_user)),
						topic: view_context.link_to(@custom_search_engine.specification.title,
							cse_path(@custom_search_engine))})
					notification.body = @reply.body
					notification.save
				end
				@flag = 'success'
				@messages = [I18n.t('human.success.reply')]
				format.js 
			else
				@flag = 'error'
				@messages = @reply.errors.full_messages
				format.js
			end
		end
	end
end
