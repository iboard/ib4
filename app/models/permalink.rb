class Permalink < ActiveRecord::Base
  belongs_to  :linkable, :polymorphic => true
  validates_uniqueness_of :url
  validates_presence_of   :url
  
  
  def self.is_destination?(check_url,requested_url)
     return true if check_url.eql?(requested_url)
     parts = requested_url.split("/").reject(&:empty?)
     return find(:first,
       :conditions => ['url= ? and linkable_id = ? and linkable_type=?',
         check_url.gsub(/\/(.*)$/,'\1'),
         parts[1].to_i,
         parts[0].camelize.singularize
       ]
     )
  end
  
end
