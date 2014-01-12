DochiApi::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  resources :photos
  resources :decks
  resources :friends
  match 'deck/:url_key' => 'decks#perma_link', :via => :get
  match 'login/facebook' => 'login#facebook', :via => :post
  match 'photos/:photo_id/like' => 'photos#like', :via => :post
  match 'photos/:photo_id/like_guest' => 'photos#like_guest', :via => :post
  match 'decks/:deck_id' => 'decks#show', :via => :post
  match 'decks/:deck_id/delete' => 'decks#delete', :via => :post
  match 'decks/friend/:friend_id' => 'decks#friend', :via => :get # todo!
  match 'device/update' => 'device#update', :via => :post
  match 'friends/show' => 'friends#show', :via => :post
  match 'friend/suggestions' => 'friends#suggestions', :via => :get
  match 'friend/create' => 'friends#create', :via => :post

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
