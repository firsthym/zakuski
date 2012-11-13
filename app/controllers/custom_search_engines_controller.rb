class CustomSearchEnginesController < ApplicationController
  before_filter :available_cses
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, 
                                      :destroy, :share, :clone]
  before_filter :correct_user, only: [:edit, :update, :share, :destroy]
  #before_filter :admin_user, only: [:destroy]
  
  # GET /custom_search_engines
  # GET /custom_search_engines.json
  def index
    respond_to do |format|
      format.html # index.html.erb
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
    @custom_search_engine.status = 'draft'
    respond_to do |format|
      if @custom_search_engine.save
        flash[:success] = I18n.t('human.success.create', item: I18n.t('human.text.cse'))
        # keep and link the new custom search engine
        keep_and_link_cse @custom_search_engine
        link_cse(@custom_search_engine)
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

  # GET /search
  def search
    respond_to do |format|
      format.html
    end
  end

  # GET /q/:query
  def query
    @query = params[:query]
    respond_to do |format|
      format.html
    end
  end

  # GET /cses/:id/keep
  def keep
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    
    respond_to do |format|
      if @keeped_custom_search_engines.include?(@custom_search_engine)
        @already_keeped = true
        @message = I18n.t('human.errors.already_keep')
        format.js
      else
        @already_keeped = false
        if user_signed_in?
          current_user.keeped_custom_search_engines.push(@custom_search_engine)
          unless current_user == @custom_search_engine.author
            Notification.messager(title: I18n.t('notification.keep', 
              {user: view_context.link_to(current_user.username, 
                user_path(current_user)),
                cse:view_context.link_to(@custom_search_engine.specification.title,
                  cse_path(@custom_search_engine))}),
                                  receiver: @custom_search_engine.author,
                                  source: 'cse')
          end
          @message = I18n.t('human.success.general')
        else
          if @keeped_custom_search_engines.count >= 10
            @message = I18n.t('human.errors.limit_cses')
            @keeped_custom_search_engines.pop(@keeped_custom_search_engines - 10)
          else
            cookies[:keeped_cse_ids] = @keeped_custom_search_engines.push(@custom_search_engine).map{ |cse| cse.id }.join(',')
          end
        end
        format.js
      end
    end
  end

  # GET /cses/:id/remove
  def remove
    @custom_search_engine = CustomSearchEngine.find(params[:id])

    respond_to do |format|
      if @keeped_custom_search_engines.include?(@custom_search_engine)
        @already_keeped = true
        if user_signed_in?
          current_user.keeped_custom_search_engines.delete(@custom_search_engine)
        else
           @keeped_custom_search_engines.delete(@custom_search_engine)
          cookies[:keeped_cse_ids] = @keeped_custom_search_engines.map{ |cse| cse.id }.join(',')
        end
        if(cookies[:linked_cseid] == params[:id])
          cookies.delete(:linked_cseid)
        end
        if @keeped_custom_search_engines.count == 0
          cookies.delete(:keeped_cse_ids)
        end
        @message = I18n.t('human.success.general')
        format.js
      else
        already_keeped = false
        @message = I18n.t('human.errors.not_keep');
        format.js
      end
    end

  end

 # GET /cses/:id/link
  def link
    @custom_search_engine = CustomSearchEngine.find(params[:id])

    respond_to do |format|

    end
  end

  # GET /cses/:id/clone
  def clone
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    if current_user.own_cse?(@custom_search_engine)
      flash[:error] = I18n.t('human.errors.clone') 
    else
      @new = CustomSearchEngine.new
      @new.node = @custom_search_engine.node
      @new.author = current_user
      @new.parent_id = @custom_search_engine.id
      @new.specification = @custom_search_engine.specification
      @new.annotations = @custom_search_engine.annotations
    end

    respond_to do |format|
      if @new.save
        Notification.messager(receiver: @custom_search_engine.author, source: 'cse',
              title: I18n.t('notification.clone', 
                      {user: view_context.link_to(current_user.username, 
                        user_path(current_user)),
                        cse:view_context.link_to(@custom_search_engine.specification.title,
                        cse_path(@custom_search_engine))}))
        keep_and_link_cse(@new)
        format.html {redirect_to edit_cse_path(@new)}
      else
        flash[:error] = I18n.t('human.errors.clone_error')
        format.html { redirect_to nodes_path }
      end
    end
  end

  def share
    respond_to do |format|
      if @custom_search_engine.update_attributes(status: "publish")
        flash[:success] = I18n.t('human.success.publish')
      else
        flash[:error] = @custom_search_engine.errors.full_messages
      end
      format.html {redirect_to cse_path(@custom_search_engine)}
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
      correct_user!(@custom_search_engine.author)
    end
end