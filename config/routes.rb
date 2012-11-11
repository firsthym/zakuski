Myapp::Application.routes.draw do
  constraints(source: /topic|cse/) do
    resources :notifications do
      collection do
        get 'clear/:source', action: :clearl, as: :clear
        get 'markread/:source', action: :mark_read, as: :mark_read
        get ':source(/:page)', action: :index, as: :source,
                      defaults: {source: 'topic'}
      end
    end
  end
  resources :users, only: [:index, :show, :edit, :update]
  resources :custom_search_engines, as: :cses, path: :cses do
    member do
      get 'link', action: :link
      get 'keep', action: :keep
      get 'clone', action: :clone
      get 'remove', action: :remove
      get 'consumers', action: :consumers
      get 'reply/:page', action: :show
    end
  end
  resources :nodes, only: [:index, :show] do
    member do
      get 'page/:page', action: :show
    end
    resources :custom_search_engines, as: :cses, path: :cses, only: [:new]
  end
  resources :replies, only: [:index, :new, :create, :edit, :update]

  match '/about', :to => 'static_pages#about'
  match '/help', :to  => 'static_pages#help'
  match '/agreement', :to => 'static_pages#agreement'

  devise_for :users, :skip => [:sessions, :registrations]  
  devise_scope :user do
    get "signin", :to => "devise/sessions#new", :as => :signin
    post 'signin', :to => 'devise/sessions#create', :as => :signin
    match 'signout', :to => 'devise/sessions#destroy', :as => :signout
    
    get 'signup', :to => 'devise/registrations#new', :as => :signup
    post 'signup', :to => 'devise/registrations#create', :as => :signup
  end

  #match '/signout', :to => 'sessions#destroy', :via => :delete

  match '/q/:query', :to => 'custom_search_engines#query', :as => 'cse_query'
  match '/search', :to => 'custom_search_engines#search', :as => 'cse_search'

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
  root :to => 'custom_search_engines#search'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
