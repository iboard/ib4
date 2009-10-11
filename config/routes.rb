ActionController::Routing::Routes.draw do |map|
  map.resources :permalinks
  map.resources :pages, :has_many => :comments
  map.resources :tags
  map.resources :comments
  map.resources :categories, :has_many => [:pages, :postings]
  map.resources :postings, :has_many => :comments
  map.resources :reset_passwords
  map.login "login", :controller => 'user_sessions', :action => 'new'
  map.logout "logout", :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions
  map.resources :users, :has_many => [:postings,:pages]
  map.set_locale '/set_locale/:locale', :controller => 'user_sessions', :action => 'set_locale'
  map.root :controller => "postings"
  map.connect ':id', :controller => :permalinks, :action => :show
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
