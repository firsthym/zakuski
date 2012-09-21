class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

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
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if signed_in?
      redirect_to root_path
      return
    end

    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    
    if !@user.agreement
      flash.now[:notice] = I18n.t('human.text.must_agree_protocol')
      render action: 'new'
      return
    end

    respond_to do |format|
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to cse.so"
        format.html { redirect_to @user}
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
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
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:error] = I18n.t('human.errors.no_privilege')
        redirect_to user_path(current_user)
      end
    end

    def admin_user
      unless current_user.admin?
        flash[:error] = I18n.t('human.errors.no_privilege')
        redirect_to user_path(current_user)
      end
    end
end
