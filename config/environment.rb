################################################################################################
# iBoard 4 environment.rb
# Project: iBoard4
# (c) 2009 by Andreas Altendorfer
# Lisence: GPL
#
# DO NOT EDIT THIS FILE IT WILL BE OVERWRITTEN BY THE NEXT GIT-PULL!
# INSTEAD EDIT YOUR environments/*.rb
################################################################################################


RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  # used gems
  config.gem "authlogic"
  config.gem "searchlogic"
  config.gem "will_paginate"
  config.gem "RedCloth"# , :lib => "redcloth", :source => "http://code.whytheluckystiff.net" 
  config.gem "paperclip"  # see http://rdoc.info/projects/thoughtbot/paperclip
  config.gem 'justinfrench-formtastic', :lib => 'formtastic', :source => 'http://gems.github.com'  
  config.gem 'vestal_versions'
  config.gem "declarative_authorization", :source => "http://gemcutter.org" 
  
  # Timezone and Locale
  config.time_zone = 'UTC'
  config.time_zone = 'Vienna'
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en
end

# SOME IMPORTANT DEFINITIONS (override them in your environments/environment.rb)
LOCALES=[:en,:de]
DEFAULT_LOCALE=:en

ExceptionNotifier.exception_recipients = EXCEPTION_NOTIFICATION_RECIPIENTS
ExceptionNotifier.sender_address       = EXCEPTION_NOTIFICATION_SENDER

USER_MENU_ITEMS = [
    {:label => :home, :url => '/'},
    {:label => :please_override_USER_MENU_ITEMS_in_your_environment_rb, :url => nil}
] unless defined? USER_MENU_ITEMS

ADMIN_MENU_ITEMS = [
  {:label => :user_listing, :url => "/users"},
  {:label => :categories, :url => "/categories"},
  {:label => :newsletters, :url => "/newsletters"},
  {:label => :invitations, :url => "/invitations"}
] unless defined? ADMIN_MENU_ITEMS

MAX_FEED_ITEMS=1024 unless defined? MAX_FEED_ITEMS

# Constants for layout
FILE_NOT_FOUND_PATH='/images/file_not_found.png' unless defined? FILE_NOT_FOUND_PATH
FILE_LOCKED_PATH='/images/file_locked.png'       unless defined? FILE_LOCKED_PATH

POSTINGS_PER_PAGE=4               unless defined? POSTINGS_PER_PAGE
BINARIES_PER_PAGE=10              unless defined? BINARIES_PER_PAGE
USERS_PER_PAGE=4                  unless defined? USERS_PER_PAGE
RIGHT_BOX_DEFAULT_WIDTH="25%"     unless defined? RIGHT_BOX_DEFAULT_WIDTH
DEFAULT_TRUNCATED_BODY_LENGTH=512 unless defined? DEFAULT_TRUNCATED_BODY_LENGTH
TEXTILIZE_HELP_LINK="http://redcloth.org/textile/writing-paragraph-text/" unless defined? TEXTILIZE_HELP_LINK


# CHARACTERS
NBSP           = '&nbsp;'  unless defined? NBSP
BR             = "<br />"  unless defined? BR
CAN_OPEN       = "&#9658;" unless defined? CAN_OPEN
IS_OPEN        = "&#9660;" unless defined? IS_OPEN
CLOSE_UP       = "&#9650;" unless defined? CLOSE_UP
GO_BACK        = "&#9664;" unless defined? GO_BACK
BACKSPACE_CHAR = "&#9003;" unless defined? BACKSPACE_CHAR
DELETE_CHAR    = "&#9003;" unless defined? DELETE_CHAR
COMMENT_HAND   = "&#9997;" unless defined? COMMENT_HAND
CHECK_OK       = "&#10004;" unless defined? CHECK_OK
CHECK_NOT_OK   = "&#10008" unless defined? CHECK_NOT_OK

def current_locale
  I18n::locale
end
