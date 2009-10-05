ActionController::Routing::Routes.draw do |map|
  map.resources :tags
  map.resources :comments
  map.resources :categories, :has_many => :postings
  map.resources :postings, :has_many => :comments
  map.resources :reset_passwords
  map.login "login", :controller => 'user_sessions', :action => 'new'
  map.logout "logout", :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions
  map.resources :users
  map.root :controller => "postings"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
