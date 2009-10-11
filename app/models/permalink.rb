class Permalink < ActiveRecord::Base
  belongs_to  :linkable, :polymorphic => true
  validates_uniqueness_of :url
  validates_presence_of   :url
  
  
  def self.is_destination?(check_url,requested_url,rootpath="postings")
     check = check_url.gsub(/\?(.*)$/,"").gsub(/^\//,"")
     rqurl = requested_url.gsub(/\?(.*)$/,"").gsub(/^\//,"")
     return true if check == rqurl || rqurl == rootpath
     permalink = rqurl.split("/").last
     rc = find_by_url(permalink)
     return rc && (check.split("/").last == permalink) || (rqurl == '' && check == rootpath)
  end
  
end
