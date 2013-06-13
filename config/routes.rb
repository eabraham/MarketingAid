MarketAid::Application.routes.draw do

  resources :oauth_consumers do
    member do
      get :callback
      get :callback2
      match 'client/*endpoint' => 'oauth_consumers#client'
    end
  end

  match "dashboard" => "dashboard#index", :as => :dashboard
  match "feed" => "feed#index", :as => :feed
  match "analytics" => "analytics#index", :as => :analytics
  match "schedule" => "schedule#index", :as => :schedule
  match "schedule/schedule_meetup_event" => "schedule#schedule_meetup_event", :via => [:put,:post]
  match "schedule/schedule_meetup_comment" => "schedule#schedule_meetup_comment", :via => [:put,:post]
  match "schedule/schedule_tweet" => "schedule#schedule_tweet", :via => [:put,:post]
  match "schedule_facebook_status" => "schedule#schedule_facebook_status_update", :via => [:put,:post]
  match "schedule/get_meetup_venues" => "schedule#get_group_venues", :as=> :get_meetup_venues
  match "schedule/get_meetup_events" => "schedule#get_group_events", :as=> :get_meetup_events
  match "services" => "oauth_consumers#index", :as=> :services

  devise_for :users
  root :to => 'dashboard#index'
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
  # match ':controller(/:action(/:id))(.:format)'
end
