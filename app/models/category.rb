# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Simple model which can be attached to any "Categorizable"
class Category < ActiveRecord::Base
  has_many :categorizables

  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many    :permalinks, :as => :linkable,
              :dependent => :destroy
              
  after_create :add_new_permalinks
  before_save  :add_new_permalinks

  def add_new_permalinks
    unless @new_permalink.blank?
      pl = self.permalinks.build(:url => @new_permalink)
      self.permalink_ids << pl
    end
  end
  
  def user
    @user ||= User.find_by_is_admin(true)
  end              
  
  
  def new_permalink=(newlink)
    if Permalink.find_by_url(newlink)
      @permalink_exists_error = true
    else
      @new_permalink = newlink
    end
  end
  
  # short title for lists and callback for ...ables
  def list_title(n=40)
    st = name[0..n].to_s
    st += "..." unless name.length <= n
    st
  end
  alias_method :title, :list_title
  
  # TODO: Check if user allowed to read this posting
  # This callback is used by tagables and therefor it is defined as this simple placeholder yet
  def read_allowed?(user)
    true
  end
  
  private
  
  def add_new_permalinks
    unless @new_permalink.blank?
      pl = self.permalinks.build(:url => @new_permalink)
      self.permalink_ids << pl
    end
  end
  
  def uniqueness_of_new_permalink
    if @permalink_exists_error
      self.errors.add( :new_permalink, t(:permalink_exists))
    end
  end
  
  
end
