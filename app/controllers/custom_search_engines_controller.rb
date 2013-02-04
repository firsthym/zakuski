class CustomSearchEnginesController < ApplicationController
  before_filter :initialize_cses
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, 
                                      :destroy, :share, :clone]
  before_filter :correct_user, only: [:edit, :update, :share, :destroy]
  before_filter :check_node, only: [:new, :create, :edit, :update, :show]
  before_filter :remove_empty_tags, only: [:create, :update]
  
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
    respond_to do |format|
      format.html do 
        if @custom_search_engine.publish? || current_user == @custom_search_engine.author
          @valid_labels = @custom_search_engine.labels.map { |l| l.name }
          @labels_hash = Hash.new
          @no_labels_arr = Array.new
          @custom_search_engine.annotations.score_desc.each do |a|
            if a.labels_list.any?
                a.labels_list.each do |l|
                    if @valid_labels.include?(l)
                        @labels_hash[l] = Array.new if @labels_hash[l].nil?
                        @labels_hash[l].push(a)
                    else
                        @no_labels_arr.push(a)
                    end
                end
            else
                @no_labels_arr.push(a)
            end  
          end
          if @custom_search_engine.status == 'publish' && current_user != @custom_search_engine.author
            @custom_search_engine.inc(:browse_count, 1)
          end
          render 'show'
        else
         flash[:error] = I18n.t('human.errors.only_publish_cse_available')
             redirect_to nodes_path  
        end
      end
      #format.json { render json: @custom_search_engine }
      format.xml { @labels = @custom_search_engine.labels }
    end
  end

  # GET /custom_search_engines/new
  # GET /custom_search_engines/new.json
  def new
    @custom_search_engine = CustomSearchEngine.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_search_engine }
    end
  end

  # GET /custom_search_engines/1/edit
  def edit
  end

  # POST /custom_search_engines
  # POST /custom_search_engines.json
  def create
    @custom_search_engine = CustomSearchEngine.new(params[:custom_search_engine])
    @custom_search_engine.author = current_user
    @custom_search_engine.status = 'draft'
    @custom_search_engine.annotations.each do |a|
      prefix = a.about.slice(/http(s)?:\/\//)
      a.about = prefix.nil? ?  "http://#{a.about}" : "#{a.about}"
    end
    respond_to do |format|
      if @custom_search_engine.save
        add_cse_to_dashboard(@custom_search_engine)
        link_cse(@custom_search_engine)
        flash[:success] = I18n.t('human.success.create', 
                                 item: I18n.t('human.text.cse'))
        format.html { redirect_to node_cse_path(@node, @custom_search_engine)}
        format.json { render json: @custom_search_engine, status: :created, 
                      location: @custom_search_engine }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_search_engine.errors, 
                      status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_search_engines/1
  # PUT /custom_search_engines/1.json
  def update
    respond_to do |format|
      @custom_search_engine.updated_at = Time.now
      if @custom_search_engine.update_attributes(params[:custom_search_engine])
        flash[:success] = I18n.t('human.success.update', item: I18n.t('human.text.cse'))
        format.html do
          if @node.present?
            redirect_to node_cse_path(@node, @custom_search_engine)
          else
            redirect_to cse_path(@custom_search_engine)
          end
        end
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
    if @custom_search_engine.present?
      if (parent = @custom_search_engine.parent).present?
        parent.children_ids.delete(@custom_search_engine.id)
        parent.save
      end
      @custom_search_engine.destroy
    end

    respond_to do |format|
      format.html { redirect_to cses_path }
      format.json { head :no_content }
    end
  end

  # GET /query(/:id/:query)
  def query
    if params[:id].present?
      @active_cse = CustomSearchEngine.find(params[:id])
      cookies[:active_cseid] = params[:id]
    else
      @active_cse = @linked_cse
    end

    @query = params[:query]
    respond_to do |format|
      if @active_cse.present? && can_access?(@active_cse)
        format.html
      else
        flash[:error] = I18n.t('human.errors.invalid_link_cse')
        format.html {redirect_to cses_path}
      end
    end
  end

  # GET /cses/:id/keep
  def keep
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    if @custom_search_engine.nil?
      @error = I18n.t('human.errors.no_records')
    elsif @keeped_cses.include?(@custom_search_engine)
      @error = I18n.t('human.errors.already_keep')
    elsif user_signed_in?
      # for members
      if current_user == @custom_search_engine.author
        @error = I18n.t('human.errors.keep_own')
      elsif @keeped_cses.count > 19
        @error = I18n.t('human.errors.limit_cses', limit: 20)
      else
        current_user.keeps_cse(@custom_search_engine)
        add_cse_to_dashboard(@custom_search_engine)
        Notification.messager(title: I18n.t('notification.keep', 
          {user: view_context.link_to(view_context.truncate(
            current_user.username, length: 15), user_path(current_user)),
            cse:view_context.link_to(
              view_context.truncate(
                @custom_search_engine.specification.title, length: 25),
              cse_path(@custom_search_engine))}),
              receiver: @custom_search_engine.author, sender: current_user,
              source: 'cse')
      end
    else
      #for guests
      if @keeped_cses.count > 9
        # guests only keep 10 cses at most
        @error = I18n.t('human.errors.limit_cses', limit: 10)
      else
        @custom_search_engine.keeped_at = Time.now
        @keeped_cses.push @custom_search_engine
        cookies[:keeped_cses] = Marshal.dump(@keeped_cses)
        add_cse_to_dashboard(@custom_search_engine)
      end
    end

    if @error.nil?
      @message = I18n.t('human.success.general')
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /cses/:id/remove
  def remove
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    if @custom_search_engine.nil?
      @error = I18n.t('human.errors.no_records')
    elsif @keeped_cses.include?(@custom_search_engine)
      if user_signed_in?
        current_user.removes_cse(@custom_search_engine)
      else
        @keeped_cses.delete(@custom_search_engine)
        @dashboard_cses.delete(@custom_search_engine)
        if @keeped_cses.count == 0
          cookies.delete(:keeped_cses)
        else
          cookies[:keeped_cses] = Marshal.dump(@keeped_cses)
        end
        if @dashboard_cses.count == 0
          cookies.delete(:dashboard_cses)
        else
          cookies[:dashboard_cses] = Marshal.dump(@dashboard_cses)
        end
      end
      cookies.delete(:linked_cseid) if(cookies[:linked_cseid] == params[:id])
    else
      @error = I18n.t('human.errors.not_keep');
    end

    if @error.nil?
      @message = I18n.t('human.success.general')
    end
    respond_to do |format|
      format.js
    end

  end

  # GET /cses/:id/clone
  def clone
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    if current_user.own_cse?(@custom_search_engine)
      flash[:error] = I18n.t('human.errors.clone') 
    else
      @new = CustomSearchEngine.new
      @new.author = current_user
      @new.specification = @custom_search_engine.specification.clone
      @new.annotations = @custom_search_engine.annotations.map { |a| a.clone }
      @new.labels = @custom_search_engine.labels.map { |l| l.clone }
      if @custom_search_engine.theme.present?
	@new.theme = @custom_search_engine.theme.clone 
      else
	@new.build_theme
      end
      @new.status = 'draft'
      @new.parent = @custom_search_engine
      @new.tags = @custom_search_engine.tags
    end

    respond_to do |format|
      if @new.present? && @new.save 
        Notification.messager(
              receiver: @custom_search_engine.author, 
              sender: current_user, source: 'cse', 
              title: I18n.t('notification.clone', 
              {user: view_context.link_to(
                    view_context.truncate(current_user.username, length: 15), 
                    user_path(current_user)),
                    cse:view_context.link_to(
                      view_context.truncate(
                        @custom_search_engine.specification.title, length: 25),
                      cse_path(@custom_search_engine))}))
        format.html {redirect_to edit_cse_path(@new)}
      else
        flash[:error] = @new.errors.full_messages
        format.html { redirect_to cse_path(@custom_search_engine) }
      end
    end
  end

  def share
    respond_to do |format|
      if @custom_search_engine.update_attribute(:status, 'publish')
        flash[:success] = I18n.t('human.success.publish')
      else
        flash[:error] = @custom_search_engine.errors.full_messages
      end
      format.html {redirect_to cse_path(@custom_search_engine)}
    end
  end

  def consumers
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    get_consumers_count = 50
    step = 20

    if params[:more].nil?
      @more = get_consumers_count
    else
      @more = params[:more].to_i + step
    end
    more = @custom_search_engine.consumers.slice(@more, step)
    if more.present?
     @more_consumers = User.in(id: more.map{|each| each["uid"]}).compact
    end
    respond_to do |format|
      format.js
    end
  end

  def save_dashboard_cses
    @new_dashboard_cse_ids = params[:saved_cses]
    # & removes the redudent cse
    @new_dashboard_cse_ids &= @new_dashboard_cse_ids
    if @new_dashboard_cse_ids.present?
      @new_dashboard_cses = []
      cses_array = (@created_cses | @keeped_cses)
      @new_dashboard_cse_ids.each do |id|
        cses_array.each do |cse|
          if cse.id.to_s == id
            @new_dashboard_cses << cse
            break
          end
        end
      end
    end 
    
    if @new_dashboard_cses.present?
      @dashboard_cses = @new_dashboard_cses
      if(user_signed_in?)
        current_user.set_dashboard_cses(@dashboard_cses)
      else
        cookies[:dashboard_cses] = Marshal.dump(@dashboard_cses)
      end
      flash[:success] = I18n.t('human.success.general')
    elsif user_signed_in?
      current_user.update_attribute(:dashboard_cses, [])
      flash[:success] = I18n.t('human.success.general')
    else
      cookies.delete(:dashboard_cses)
      flash[:success] = I18n.t('human.success.general')
    end

    respond_to do |format|
      format.html {redirect_to cses_path}
    end
  end

  def save_keeped_cses
    @new_keeped_cse_ids = params[:saved_cses]
    if @new_keeped_cse_ids.present?
      @new_keeped_cse_ids &= @new_keeped_cse_ids
      @new_keeped_cses = []
      @new_keeped_cse_ids.each do |id|
        @keeped_cses.each do |cse|
          if cse.id.to_s == id
            @new_keeped_cses << cse
            break
          end
        end
      end
    end

    if @new_keeped_cses.present?
      diff_cses = @keeped_cses - @new_keeped_cses
      @keeped_cses = @new_keeped_cses
      @dashboard_cses &= (@keeped_cses | @created_cses)
      if user_signed_in?
        current_user.set_keeped_cses(@keeped_cses)
        # update dashboard cses with new keeped cses
        current_user.set_dashboard_cses(@dashboard_cses)
        
        if(diff_cses.present?)
          diff_cses.each do |cse|
            cse.consumers.delete_if{|each| each["uid"] == current_user.id}
            cse.update(validate: false)
          end
        end
      else
        cookies[:keeped_cses] = Marshal.dump(@keeped_cses)
        cookies[:dashboard_cses] = Marshal.dump(@dashboard_cses)
      end
      flash[:success] = I18n.t('human.success.general')
    elsif user_signed_in?
      current_user.update_attribute(:keeped_cses, [])

      @keeped_cses.each do |cse|
        cse.consumers.delete_if{|each| each["uid"] == current_user.id}
        cse.update(validate: false)
      end
      @keeped_cses = []
      flash[:success] = I18n.t('human.success.general')
    else
      cookies.delete(:keeped_cses)
      flash[:success] = I18n.t('human.success.general')
    end
    respond_to do |format|
      format.html {redirect_to cses_path}
    end
  end

  def save_created_cses
    if params[:saved_cses].present?
      saved_cses = params[:saved_cses]
    else
      saved_cses = []
    end
    if saved_cses.any?
      current_user.custom_search_engines.each do |cse|
        unless saved_cses.include? cse.id.to_s
          if cse.parent.present?
            cse.parent.children_ids.delete(cse.id)
            cse.parent.save
          end
          cse.destroy 
        end
      end
    else
      current_user.custom_search_engines.clear
    end
    respond_to do |format|
      if current_user.save
        flash[:success] = I18n.t('human.success.general')
        format.html { redirect_to cses_path }
      else
        flash[:error] = I18n.t('human.errors.general')
        format.html { redirect_to cses_path }
      end
    end
  end

  private
    def correct_user
      @custom_search_engine = CustomSearchEngine.find(params[:id])
      correct_user!(@custom_search_engine.author)
    end

    def remove_empty_tags
      params[:custom_search_engine][:tag_ids].delete_if { |t| t.blank? }
    end

    def check_node
      begin
        @node = Node.find_by(title: params[:node_id]) if params[:node_id].present?
        if params[:action] == 'new' || params[:action] == 'create'
          raise if @node.blank?
        end
        if params[:id].present? 
          @custom_search_engine = CustomSearchEngine.find(params[:id])
          raise if @custom_search_engine.blank?
        end 
      rescue
        respond_to do |format|
          format.html do
            flash[:error] = I18n.t('human.errors.no_records')
            redirect_to nodes_path
          end
        end
      end
    end
end
