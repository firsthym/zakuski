class UsersController < ApplicationController
  before_filter :initialize_cses, only: [:show]
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  #before_filter :admin_user, only: [:destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if params[:user][:avatar].blank?
      params[:user].delete(:avatar)
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: I18n.t('human.success.general') }
        format.json { head :no_content }
      else
        @user.reload
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.destroy
        format.html { flash[:success] = I18n.t('human.text.success.delete_user'); redirect_to users_url}
        format.json { head :no_content }
      else
        format.html { flash[:error] = I18n.t('human.text.errors.delete_user'); redirect_to users_url}
        format.json { head :no_content }
      end
    end
  end

  private
    def correct_user
      @user = User.find_by(username: params[:id])
      if @user.nil?
        flash[:error] = I18n.t('human.errors.no_user')
        redirect_to root_path
      else
        correct_user!(@user)
      end
    end
    def initialize_cses
      @user = User.find_by(username: params[:id])
      if(@user.nil?)
        flash[:error] = I18n.t('human.errors.no_user')
        redirect_to root_path
      else
        @keeped_cses = @user.get_keeped_cses
        @created_cses = @user.get_created_cses
      end
    end
end
