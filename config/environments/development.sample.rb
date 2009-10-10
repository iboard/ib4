# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address      => 'ib1.iboard.cc',
  :port         => 25,
  :domain       => "iboard.cc",
  :authentication=>"login",
  :user_name    => "USERNAME",
  :password     => "SECRET"
}

LOCALHOST_NAME='ib4.local'

USER_MENU_ITEMS= [
    {:label => :about, :url => '/welcome'},
    {:label => :development, :url => '/tags/development'},
    {:label => :all_pages, :url => '/pages'},
    {:label => :app_postings, :url => '/postings'}
]
