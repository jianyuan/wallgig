Wallgig::Application.routes.draw do
  concern :commentable do
    resources :comments, only: [:index, :new, :create]
  end

  concern :reportable do
    resources :reports, only: [:new, :create]
  end

  root 'wallpapers#index'

  get 'forums' => 'forums#official_index', as: :official_forums

  resources :groups do
    resources :forums do
      resources :forum_topics, path: :topics, except: [:index], shallow: true do
        concerns :commentable

        concerns :reportable

        member do
          patch :pin
          patch :unpin
          patch :lock
          patch :unlock
          patch :hide
          patch :unhide
        end
      end
    end

    resources :collections

    resources :favourites

    member do
      get :apps
      patch :update_apps
      post :join
      delete :leave
    end
  end

  resources :categories

  # Account
  namespace :account do
    # Collections
    resources :collections, except: :show do
      member do
        patch :move_up
        patch :move_down
      end

      resources :wallpapers
    end

    resource :profile do
      member do
        delete :remove_profile_cover
      end
    end
  end

  # Collections
  resources :collections, only: [:index, :show]

  # Comments
  resources :comments, only: [:index, :edit, :update, :destroy] do
    concerns :reportable
    member do
      get 'reply'
    end
  end

  # Users
  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  resources :users, only: [:show] do
    concerns :commentable

    resources :collections, only: [:index]

    resources :favourites, only: [:index]
  end

  # OPTIMIZE
  resource :user do
    post 'update_screen_resolution'
  end

  # Wallpapers
  get 'w/:id' => 'wallpapers#show', id: /\d+/, as: :short_wallpaper
  resources :wallpapers do
    concerns :commentable
    concerns :reportable

    collection do
      post :save_search_params
    end

    member do
      get :collections
      post :toggle_collect
      post :toggle_favourite
      post :set_profile_cover
      get :history
      patch 'update_purity/:purity', action: :update_purity, as: :update_purity
      get ':width/:height' => 'wallpapers#show', width: /\d+/, height: /\d+/, as: :resized
    end


    # TODO deprecate
    resource :favourite do
      member do
        post :toggle
      end
    end
  end

  # API
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :sessions, only: :create

      resources :tags, only: [:index]

      resources :users, only: [:me] do
        collection do
          get :me
        end

        resources :wallpapers, only: [:index]
        resources :favourites, only: [:index]
      end

      resources :wallpapers, only: [:index, :show, :create]
    end
  end

  # Oauth
  use_doorkeeper

  # Admin routes
  authenticate :user, -> (user) { user.developer? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  ActiveAdmin.routes(self)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
