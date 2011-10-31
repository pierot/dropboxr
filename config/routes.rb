Dropboxr::Application.routes.draw do
  
  get 'image/:id(/:size)' => 'image#index', :as => 'image'

  namespace :manage do 
    resources :build do
      collection do
        get :building
        get :done
        get :error
      end
    end

    resources :install do
      collection do
        get :callback
        get :index
        get :done
        get :error
      end
    end

    # match "build/building" => 'build#building'
    # match "build/done" => 'build#done'
    # match "build/error" => 'build#error'

    # match "install" => 'install#index'

    # match "install/callback" => 'install#callback'
    # match "install/error" => 'install#error'
    # match "install/done" => 'install#done'
    
    # match "/" => 'manage#index', :as => 'manage'
  end

  resources :manage

  match 'fresh' => 'pages#fresh'
  match 'about' => 'pages#about'

  resources :albums, :only => [:show, :index] do
    resources :photos, :only => [:show]
  end

  root :to => 'albums#index'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
