Wallgig::Application.routes.draw do
  resources :favourites

  root 'wallpapers#index'

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
  end

  # Collections
  resources :collections, only: :show

  # Users
  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  resources :users

  # Wallpapers
  resources :wallpapers do
    collection do
      get 'elasticsearch'
    end

    member do
      get 'history'
      patch 'update_purity/:purity', action: :update_purity, as: :update_purity
    end

    resources :favourites
  end

  # API
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users, only: [:me] do
        get 'me', on: :collection
      end
    end
  end

  # Oauth
  use_doorkeeper

  # Admin routes
  authenticate :user, ->(u) { u.admin? } do
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
