ActionController::Routing::Routes.draw do |map|
  map.resources :binaries, :member => { :download => :get }
  map.resources :friendships
  map.resources :invitations
  map.resources :feed
  map.rss       '/rss', :controller => 'feed', :action => 'index', :format => :rss
  map.resources :permalinks
  map.resources :pages, :has_many => :comments
  map.resources :tags
  map.resources :comments
  map.resources :categories, :has_many => [:pages, :postings]
  map.resources :postings, :has_many => :comments
  map.resources :reset_passwords
  map.login "login", :controller => 'user_sessions', :action => 'new'
  map.logout "logout", :controller => 'user_sessions', :action => 'destroy'
  map.register "/register/:token", :controller => 'users', :action => 'new'
  map.connect   '/search', :controller => 'application', :action => 'search'
  map.resources :user_sessions
  map.resources :users, :has_many => [:postings,:pages,:invitations,:comments,:binaries]
  map.resources :newsletters, 
                 :has_many => [:newsletter_subscriptions, :newsletter_issues],
                 :member => {
                   :deliver_issue => :get
                 }
  map.resources :newsletter_blacklist
  map.resources :newsletter_issues, :member =>  { :deliver => :get, :deliver_test  => :get  }
  map.subscriptions '/subscriptions/:mail/:token', :controller => "newsletters", :action => 'subscriptions'
  map.set_locale '/set_locale/:locale', :controller => 'user_sessions', :action => 'set_locale'
  map.root :controller => "postings"
  map.connect ':id', :controller => :permalinks, :action => :show
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '*path', :controller => 'permalinks', :action => 'show'
end
