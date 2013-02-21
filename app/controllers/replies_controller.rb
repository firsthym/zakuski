class RepliesController < ApplicationController
	before_filter :authenticate, only: [:create]
	before_filter :validate_reply, only: [:create] 
	def create
			@post = @reply.post
			@reply.user = current_user
			
			respond_to do |format|
					if @reply.save
							at_users
							unless current_user == @post.author
								Notification.messager(
									title: I18n.t('notification.new_reply', 
											{user: view_context.link_to(
												view_context.truncate(
													current_user.username, length: 15),
													user_path(current_user)),
											post: view_context.link_to(
												view_context.truncate(
													@post.title, 
													length: 25),
													cse_path(@post))}),
									source: 'discus',
									body: @reply.body,
									receiver: @post.author,
									sender: current_user
									)
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

	private
		def at_users
				user_names = @reply.body.scan(/@(\w+)/).map{|each| each[0]}
				user_names &= user_names
				@post = @reply.post
				User.in(username: user_names).each do |u|
						if u.present? && u != current_user && u != @post.author
								Notification.messager(
									title: I18n.t('notification.at',
											{user: view_context.link_to(
												view_context.truncate(current_user.username, length: 15), 
												user_path(current_user)),
											 discus:view_context.link_to(
												 view_context.truncate(
													@post.title, 
													length: 25),
												cse_path(@post))}),
												receiver: u, sender: current_user, source: 'discus', 
												body: @reply.body)
						end
				end
		end

		def validate_reply
			@reply = Reply.new(params[:reply])
			@messages = []
			# can not reply in 5 seconds
			last_reply = current_user.replies.last
			if last_reply.present?
				if (Time.now.to_i - last_reply.created_at.to_i) < 5
					@flag = 'error'
			@messages << I18n.t('reply.too_short')
	end
			end

			if @flag.present? && @flag == 'error'
				respond_to do |format|
					format.js { render 'create' }
				end
			end
		end

		def authenticate
			@messages = []
			unless user_signed_in?
				@flag = 'error'
				@messages << I18n.t('devise.failure.unauthenticated')
				respond_to do |format|
					format.js { render 'create' }
				end
			end
		end
end
