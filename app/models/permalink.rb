class Permalink < ActiveRecord::Base
  belongs_to  :linkable, :polymorphic => true
  validates_uniqueness_of :url
  validates_presence_of   :url
  
  
  def self.is_destination?(check_url,requested_url)
     return true if check_url == requested_url
     permalink = requested_url.split("/").last
     rc = find_by_url(permalink)
     logger.info("\n\nSEARCHING #{permalink} FOUND #{(rc ? rc.url : 'nil')} CHECK_URL #{check_url}\n\n")
     return rc && check_url[1..-1].split("/").last == permalink 
  end
  
end
