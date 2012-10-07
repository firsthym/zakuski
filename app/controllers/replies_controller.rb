class RepliesController < ApplicationController
	def create
		@reply = Reply.new(params[:reply])
		@reply.user = current_user
		
		respond_to do |format|
			if @reply.save
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
