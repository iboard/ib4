# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# A Posting has a subject and a body. It belongs to one user and may have many categories as an Categorizable
class Posting < ActiveRecord::Base
  
  belongs_to  :user                                                 # the user a posting was written by
  
  has_many    :categorizables, :as => :categorizable                # Jointable for categories
  has_many    :categories, :through => :categorizables              # Categories this posting belongs to
  
  has_many    :tags,     :as => :tagable, :dependent => :destroy    # Tags assigned to this posting
  
  after_create :assign_tags
  
  validates_presence_of :subject, :body
  
  def tagstring
    tags.map(&:name).join(",")
  end
  
  def tagstring=(newstring)
    if self.new_record?
      @save_tags = newstring
    else
      tags.delete_all
      newstring.split(",").sort.uniq.each do |t|
        tags.create( :tagable_id => id, :tagable_type => self.class.to_s, :name => t )
      end
    end
  end  


  # short title for lists and callback for ...ables
  def list_title(n=40)
    st = subject[0..n].to_s
    st += "..." unless subject.length <= n
    st
  end
    
  # TODO: Check if user allowed to read this posting
  # This callback is used by tagables and therefor it is defined as this simple placeholder yet
  def read_allowed?(user)
    true
  end
  
  private
  
  def assign_tags
    if @save_tags
      self.tagstring=(@save_tags)
    end
  end
end
