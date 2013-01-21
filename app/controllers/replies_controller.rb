class RepliesController < ApplicationController
  before_filter :validate_reply, only: [:create] 
  def create
      @custom_search_engine = @reply.custom_search_engine
      @reply.user = current_user
      
      respond_to do |format|
          if @reply.save
              at_users
              unless current_user == @custom_search_engine.author
                  notification = Notification.new
                  notification.user = @custom_search_engine.author
                  notification.source = 'discus'
                  notification.title = I18n.t('notification.new_reply', 
                      {user: view_context.link_to(
                        view_context.truncate(
                          current_user.username, length: 15),
                          user_path(current_user)),
                      topic: view_context.link_to(
                        view_context.truncate(
                          @custom_search_engine.specification.title, 
                          length: 25),
                          cse_path(@custom_search_engine))})
                  notification.body = @reply.body
                  notification.sender = current_user.id
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

  private
    def at_users
        user_names = @reply.body.scan(/@(\w+)/).map{|each| each[0]}
        user_names &= user_names
        User.in(username: user_names).each do |u|
            if u.present? && u != current_user && u != @reply.custom_search_engine.author
                Notification.messager(
                  title: I18n.t('notification.at',
                      {user: view_context.link_to(
                        view_context.truncate(current_user.username, 15), 
                        user_path(current_user)),
                       discus:view_context.link_to(
                         view_context.truncate(
                          @custom_search_engine.specification.title, 
                          length: 25),
                        cse_path(@reply.custom_search_engine))}),
                        receiver: u, sender: current_user, source: 'discus', 
                        body: @reply.body)
            end
        end
    end

    def validate_reply
      @reply = Reply.new(params[:reply])
      # can not reply in 5 seconds
      last_reply = current_user.replies.last
      @messages = []
      if (Time.now.to_i - last_reply.created_at.to_i) < 5
        @flag = 'error'
        @messages << I18n.t('reply.too_short')
      end

      if @flag.present? && @flag == 'error'
        respond_to do |format|
          format.js { render 'create' }
        end
      end
    end
end
