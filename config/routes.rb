Myapp::Application.routes.draw do
  resources :users
  resources :custom_search_engines
  resources :sessions, only: [:new, :destroy, :create]
  resources :nodes, only: [:index]

  match '/about', :to => 'static_pages#about'
  match '/help', :to  => 'static_pages#help'
  match '/agreement', :to => 'static_pages#agreement'

  match '/signup', :to => 'users#new'

  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy', :via => :delete

  match '/nodes', :to => 'nodes#index', :as => 'node_index'
  match '/nodes/:id', :to => 'nodes#show', :as => 'node_show'

  match '/cse', :to => 'custom_search_engines#index', :as => 'cse_index'
  match '/cse/new/:node_id', :to => 'custom_search_engines#new', :as => 'cse_new'
  match '/cse/get/:id', :to => 'custom_search_engines#get', :as => 'cse_get'
  match '/cse/:id/edit', :to => 'custom_search_engines#edit', :as => 'cse_edit' 
  match '/cse/:id(.:format)', :to => 'custom_search_engines#show', :as => 'cse_show'
  match '/:id/q/:query', :to => 'custom_search_engines#query', :as => 'cse_query'

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
  root :to => 'custom_search_engines#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
