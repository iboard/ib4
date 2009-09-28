ActionController::Routing::Routes.draw do |map|
  map.resources :reset_passwords
  map.login "login", :controller => 'user_sessions', :action => 'new'
  map.logout "logout", :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions
  map.resources :welcomes
  map.resources :users
  map.root :controller => "welcomes"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  
end
