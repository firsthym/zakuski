class CustomSearchEnginesController < ApplicationController
  before_filter :signed_in_user, only: [:index, :new, :create, :edit, :update, :destroy, :link, :cancel]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
  # GET /custom_search_engines
  # GET /custom_search_engines.json
  def index
    @custom_search_engines = current_user.custom_search_engines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_search_engines }
    end
  end

  # GET /custom_search_engines/1
  # GET /custom_search_engines/1.json
  def show
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    
    @filter_annotations = @custom_search_engine.annotations.find_all{|a| a.mode == 'filter'}
    @exclude_annotations = @custom_search_engine.annotations.find_all{|a| a.mode == 'exclude'}
    @boost_annotations = @custom_search_engine.annotations.find_all{|a| a.mode == 'boost'}
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @custom_search_engine }
      format.xml
    end
  end

  # GET /custom_search_engines/new
  # GET /custom_search_engines/new.json
  def new
    @custom_search_engine = CustomSearchEngine.new
    @custom_search_engine.specification = Specification.new
    @custom_search_engine.annotations = [Annotation.new]
    @custom_search_engine.node = Node.find(params[:node_id])
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_search_engine }
    end
  end

  # GET /custom_search_engines/1/edit
  def edit
    @custom_search_engine = CustomSearchEngine.find(params[:id])
  end

  # POST /custom_search_engines
  # POST /custom_search_engines.json
  def create
    @custom_search_engine = CustomSearchEngine.new(params[:custom_search_engine])
    @custom_search_engine.author = current_user
    respond_to do |format|
      if @custom_search_engine.save
        flash[:success] = I18n.t('human.success.create', item: I18n.t('human.text.cse'))
        format.html { redirect_to cse_path(@custom_search_engine)}
        format.json { render json: @custom_search_engine, status: :created, location: @custom_search_engine }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_search_engine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_search_engines/1
  # PUT /custom_search_engines/1.json
  def update
    respond_to do |format|
      if @custom_search_engine.update_attributes(params[:custom_search_engine])
        flash[:success] = I18n.t('human.success.update', item: I18n.t('human.text.cse'))
        format.html { redirect_to cse_path(@custom_search_engine) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @custom_search_engine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_search_engines/1
  # DELETE /custom_search_engines/1.json
  def destroy
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    @custom_search_engine.destroy

    respond_to do |format|
      format.html { redirect_to cses_url }
      format.json { head :no_content }
    end
  end

  # GET /
  def home
  end


  # GET /:id/q/:query
  def query
    @query = params[:query]
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # GET /cse/link/:id
  def link
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    
    respond_to do |format|
      if @custom_search_engine.consumers.include?(current_user)
        @already_link = true
        @message = I18n.t('human.errors.already_link')
        format.js
      else
        @already_link = false
        current_user.linking_custom_search_engines.push(@custom_search_engine)
        @custom_search_engine.consumers.push(current_user)
        @message = I18n.t('human.success.general')
        format.js
      end
    end
  end

  # GET /cse/cancel/:id
  def cancel
    @custom_search_engine = CustomSearchEngine.find(params[:id])

    respond_to do |format|
      if @custom_search_engine.consumers.include?(current_user)
        @already_link = true
        @custom_search_engine.consumers.delete(current_user)
        current_user.linking_custom_search_engines.delete(@custom_search_engine)
        @message = I18n.t('human.success.general')
        format.js
      else
        already_link = false
        @message = I18n.t('human.errors.not_link');
        format.js
      end
    end

  end

  def consumers
    @custom_search_engine = CustomSearchEngine.find(params[:id])

    if params[:more].nil?
      @more = 10
    else
      @more = params[:more].to_i + 10
    end
    @more_consumers = @custom_search_engine.consumers.slice(@more, 10)

    respond_to do |format|
      format.js
    end
  end

  private
    def correct_user
      @custom_search_engine = CustomSearchEngine.find(params[:id])
      unless current_user?(@custom_search_engine.author)
        flash[:error] = I18n.t('human.errors.no_privilege')
        redirect_to root_path
      end
    end

    def admin_user
      unless current_user.admin?
        flash[:error] = I18n.t('human.errors.no_privilege')
        redirect_to root_path
      end
    end
end
