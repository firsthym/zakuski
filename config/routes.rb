Myapp::Application.routes.draw do
	scope "/:locale", locale: /en|zh-CN/ do
		resources :custom_search_engines, as: :cses, 
			path: :cses, only: [:new, :create, :show, :edit, :update] do
				get 'reply/:page', action: :show
		end
		resources :custom_search_engines, as: :cses, path: :cses do
			member do
				get 'link', action: :link
				get 'keep', action: :keep
				get 'clone', action: :clone
				get 'remove', action: :remove
				get 'consumers(/:more)', action: :consumers
				get 'share', action: :share
			end
			collection do
				post 'dashboard/save', action: :save_dashboard_cses
				post 'keepedcses/save', action: :save_keeped_cses
				post 'createdcses/save', action: :save_created_cses
			end
		end

		resources :topics, only: [:new, :create, :show, :edit, :update] do
			get 'reply/:page', action: :show
		end

		resources :users, only: [:index, :show, :edit, :update]

		devise_for :users, :skip => [:sessions, :registrations, 
																		:confirmations, :passwords]  
		devise_scope :user do
			get "signin", :to => "devise/sessions#new", :as => :new_user_session
			post 'signin', :to => 'devise/sessions#create', :as => :user_session
			match 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
		
			get 'signup', :to => 'registrations#new', :as => :new_user_registration
			post 'signup', :to => 'registrations#create', :as => :user_registration
			
			get 'confirm/send', :to => 'devise/confirmations#new', :as => :new_user_confirmation
			post 'confirm', :to => 'devise/confirmations#create', :as => :user_confirmation
			get 'confirm/:confirmation_token', :to => 'devise/confirmations#show',
																				 :as => :confirmation

			get 'password/forget', :to => 'devise/passwords#new', :as => :new_user_password
			post 'password', :to => 'devise/passwords#create', :as => :user_password
			get 'password/reset/:reset_password_token', 
						:to => 'devise/passwords#edit', :as => :edit_user_password
			put 'password', :to => 'devise/passwords#update', :as => :user_password
		end

		match '/about', :to => 'static_pages#about'
		match '/help', :to  => 'static_pages#help'
		match '/agreement', :to => 'static_pages#agreement'
		match '/search', :to => 'custom_search_engines#query', :as => 'cse_search'
		match '/q/:id(/:query)', :to => 'custom_search_engines#query', 
															:query =>/.*/, :as => 'cse_query'
		# The priority is based upon order of creation:
		# first created -> highest priority.

		# Sample of regular route:
		#   match 'products/:id' => 'catalog#view'
		# Keep in mind you can assign values other than :controller and :action

		# Sample of named route:
		#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
		# This route can be invoked with purchase_url(:id => product.id)

		# Sample resource route (maps HTTP verbs to controller actions automatically):
		#   resources :products

		# Sample resource route with options:
		#   resources :products do
		#     member do
		#       get 'short'
		#       post 'toggle'
		#     end
		#
		#     collection do
		#       get 'sold'
		#     end
		#   end

		# Sample resource route with sub-resources:
		#   resources :products do
		#     resources :comments, :sales
		#     resource :seller
		#   end

		# Sample resource route with more complex sub-resources
		#   resources :products do
		#     resources :comments
		#     resources :sales do
		#       get 'recent', :on => :collection
		#     end
		#   end

		# Sample resource route within a namespace:
		#   namespace :admin do
		#     # Directs /admin/products/* to Admin::ProductsController
		#     # (app/controllers/admin/products_controller.rb)
		#     resources :products
		#   end

		# You can have the root of your site routed with "root"
		# just remember to delete public/index.html.
		# See how all your routes lay out with "rake routes"

		# This is a legacy wild controller route that's not recommended for RESTful applications.
		# Note: This route will make all actions in every controller accessible via GET requests.
		# match ':controller(/:action(/:id))(.:format)'
		
		scope "/:post_type", post_type: /cses|topics/, defaults: {post_type: "cses"} do
			constraints(source: /discus|cse/) do
				resources :notifications do
					collection do
						get 'clear/:source', action: :clear, as: :clear
						get 'markread/:source', action: :mark_read, as: :mark_read
						get ':source(/:page)', action: :index, as: :source,
													defaults: {source: 'discus'}
					end
				end
			end

			resources :tags, only: [:filter_by_tag, :show]
			resources :nodes, only: [:index, :show]
			resources :replies, only: [:index, :new, :create, :edit, :update]
		end
	end
	
	match '/:locale' => 'nodes#index', post_type: "cses", locale: "zh-CN"
	
	root :to => 'nodes#index', post_type: "cses"
end