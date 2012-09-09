
class CustomSearchEnginesController < ApplicationController
  # GET /custom_search_engines
  # GET /custom_search_engines.json
  def index
    @custom_search_engines = CustomSearchEngine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_search_engines }
    end
  end

  # GET /custom_search_engines/1
  # GET /custom_search_engines/1.json
  def show
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @custom_search_engine }
    end
  end

  # GET /custom_search_engines/new
  # GET /custom_search_engines/new.json
  def new
    @custom_search_engine = CustomSearchEngine.new
    @custom_search_engine.specification = Specification.new
    @custom_search_engine.annotations = [Annotation.new]

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
    @custom_search_engine.specification = Specification.new(params[:specification])
    @custom_search_engine.annotations = [Annotation.new(params[:annotations])]

    respond_to do |format|
      if @custom_search_engine.save
        format.html { redirect_to cse_show_path(@custom_search_engine), notice: 'Custom search engine was successfully created.' }
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
    @custom_search_engine = CustomSearchEngine.find(params[:id])

    respond_to do |format|
      if @custom_search_engine.update_attributes(params[:custom_search_engine])
        format.html { redirect_to @custom_search_engine, notice: 'Custom search engine was successfully updated.' }
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
      format.html { redirect_to custom_search_engines_url }
      format.json { head :no_content }
    end
  end

  # GET /custom_search_engine/:id/q/:query
  def query
    @custom_search_engine = CustomSearchEngine.find(params[:id])
    @query = params[:query]

    respond_to do |format|
      format.html
    end
  end
end
