Dropboxr::Application.routes.draw do
  mount SecureResqueServer.new, :at => "/resque"

  get 'image/:id(/:size)' => 'image#index', :as => 'image'

  namespace :manage do
    resources :qeue do
      collection do
        get :cache
        get :build
      end
    end

    resources :build do
      collection do
        get :building
        get :collecting
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
  end

  resources :manage

  match 'fresh' => 'pages#fresh'
  match 'about' => 'pages#about'

  resources :albums, :only => [:show, :index] do
    resources :photos, :only => [:show]
  end

  root :to => 'albums#index'
end
