# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# A Posting has a subject and a body. It belongs to one user and may have many categories as an Categorizable
class Posting < ActiveRecord::Base
  
  belongs_to  :user                                                 # the user a posting was written by
  
  has_many    :categorizables, :as => :categorizable,               # Jointable for categories
              :dependent => :destroy 
              
  has_many    :categories, :through => :categorizables              # Categories this posting belongs to
  
  has_many    :tags,     :as => :tagable, :dependent => :destroy    # Tags assigned to this posting
  
  has_many    :comments, :as => :commentable,                       # Comments for this posting
              :dependent => :destroy

  has_many     :group_restrictions, :as => :restrictable, :dependent => :destroy

  after_create :assign_tags,:assign_restrictions
  
  validates_presence_of :subject, :body
  
  after_save   :update_timestamps,:assign_restrictions
  
  def tagstring
    tags.map(&:name).join(", ")
  end
  
  def tagstring=(newstring)
    if self.new_record?
      @save_tags = newstring
    else
      tags.delete_all
      newstring.split(",").sort.uniq.each do |t|
        tags.create( :tagable_id => id, :tagable_type => self.class.to_s, :name => t.strip.camelize )
      end
    end
  end  

  def group_restrictions=(restrictions)
     @restrictions_to_save = restrictions
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
    return false if self.draft && self.user != user
    all_categories_public = (self.categories.detect { |c| !c.public }).nil?
    return true unless self.group_restrictions.any? || (user.nil? && !all_categories_public)
    return true if self.group_restrictions.empty? && user && all_categories_public
    return false unless user
    group_restrictions.each do |r|
      unless user.group_memberships.find_by_usergroup_id(r.usergroup.id).nil?
        logger.info("\n**** GRANT ACCESS TO GROUP #{r.usergroup.name}")
        return true
      end
    end
    return false  
  end
  
  def allowed_users
    all_cagegories_public = (self.categories.detect { |c| !c.public }).empty?
    if group_restrictions.empty? && self.draft == false && all_categories_public
      logger.info("\n** ALLOW PUBLIC ACCESS TO #{self.subject}")
      return true
    end
    rc = [ self.user ]
    unless self.draft == true
      rc << group_restrictions.map(&:usergroup).map { |grp| grp.group_memberships.map(&:user)}.flatten
    end
    logger.info("\n** ALLOW ACCESS TO #{self.subject} TO #{rc.flatten.uniq.map(&:username).join(",")}\n")
    return rc.flatten.uniq
  end
  
  def rss_body
    body.to_s
  end
  
  
  
  private
  
  def assign_tags
    if @save_tags
      self.tagstring=(@save_tags)
    end
  end
  
  def update_timestamps
    m = self.tags + self.categorizables 
    m.each  { |t| t.updated_at = self.updated_at; t.save }
  end
  
  def assign_restrictions
      group_restrictions.delete_all
      if @restrictions_to_save
        @restrictions_to_save.each do |r|
          x = group_restrictions.create( :usergroup_id => r[0].to_i )
          logger.info("\n** ADDED RESTRICTION #{x.inspect}\n")
        end
      end
  end
  
end
