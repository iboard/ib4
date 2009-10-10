# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
# doesn't work - RAILS_ENV = 'production' unless defined? RAILS_ENV

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "authlogic"
  config.gem "searchlogic"
  config.gem "will_paginate"
  config.gem "RedCloth", :lib => "redcloth", :source => "http://code.whytheluckystiff.net" 
  config.gem "paperclip"  # see http://rdoc.info/projects/thoughtbot/paperclip
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

# SOME IMPORTANT DEFINITIONS (override them in your environments/environment.rb)

USER_MENU_ITEMS= [
    {:label => :home, :url => '/'},
    {:label => :please_override_USER_MENU_ITEMS_in_your_environment_rb, :url => nil}
] unless defined? USER_MENU_ITEMS

# Constants for layout
POSTINGS_PER_PAGE=4
USERS_PER_PAGE=4
TEXTILIZE_HELP_LINK="http://redcloth.org/textile/writing-paragraph-text/"
RIGHT_BOX_DEFAULT_WIDTH="25%"
DEFAULT_TRUNCATED_BODY_LENGTH=512

# CHARACTERS
NBSP           = '&nbsp;'
BR             = "<br />"
CAN_OPEN       = "&#9658;"
IS_OPEN        = "&#9660;"
CLOSE_UP       = "&#9650;"
GO_BACK        = "&#9664;"
BACKSPACE_CHAR = "&#9003;"
DELETE_CHAR    = "&#9003;"
COMMENT_HAND   = "&#9997;"
