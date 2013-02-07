class TagsController < ApplicationController
  before_filter :initialize_cses
  def show
    begin
      @selected_node = Node.find_by(title: params[:node_id])
      @tags = @selected_node.tags
      @tag = Tag.find_by(name: params[:id])
      @tag.browse_count += 1
      @tag.update
      @custom_search_engines = @tag.custom_search_engines.recent.publish.page(params[:page])

      respond_to do |format|
        format.html { render 'nodes/layout'}
      end
    rescue
      respond_to do |format|
        flash[:error] = I18n.t('human.errors.no_records')
        format.html { render 'nodes/layout' }
      end
    end
  end
end
