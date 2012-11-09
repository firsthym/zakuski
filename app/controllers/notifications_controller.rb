
class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :available_source

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = current_user.notifications.recent(@source).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.js
    end
  end

  #GET /notifications/clear/:source
  def clear
    current_user.notifications.where(source: @source).delete_all
    respond_to do |format|
      format.html {redirect_to source_notifications_path(source: @source)}
    end
  end

  #GET /notifications/markread/:source
  def mark_read
    current_user.notifications.where(source: @source, read: false).update_all(read: true)
    respond_to do |format|
      format.html {redirect_to source_notifications_path(source: @source)}
    end
  end

  private
    def available_source
      @source = params[:source] || 'topic'
    end
end
