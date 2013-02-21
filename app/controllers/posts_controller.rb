class PostsController < ApplicationController
	before_filter :initialize_cses
	before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update, :destroy]
	before_filter :check_node, only: [:new, :create, :edit, :update, :show]

	def index
	end

	def show
	end

	def new
	end

	def edit
	end

	def create
	end

	def update
	end

	def destroy
	end

	private
		def correct_user
			@post = Post.find(params[:id])
			correct_user!(@post.author)
		end

		def check_node
			begin
				@node = Node.find_by(title: params[:node_id]) if params[:node_id].present?
				if params[:action] == 'new' || params[:action] == 'create'
					raise if @node.blank?
				end
				if params[:id].present? 
					@post = Post.find(params[:id])
					raise if @post.blank?
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