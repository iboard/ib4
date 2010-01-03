class Page < ActiveRecord::Base
  
  versioned
  acts_as_tree :order => :position
  
  belongs_to  :user                                                 # the user a posting was written by
  
  has_many    :categorizables, :as => :categorizable,               
              :dependent => :destroy                                # Jointable for categories
  has_many    :categories, :through => :categorizables              # Categories this posting belongs to
  
  has_many    :tags,     :as => :tagable, :dependent => :destroy    # Tags assigned to this posting
  
  has_many    :comments, :as => :commentable,                       # Comments for this posting
              :dependent => :destroy
              
  has_many    :permalinks, :as => :linkable,
              :dependent => :destroy
  
  after_create :assign_tags, :add_new_permalinks, :assign_restrictions
  before_save  :add_new_permalinks
  after_save   :update_timestamps, :assign_restrictions
  
  has_many     :group_restrictions, :as => :restrictable, :dependent => :destroy

  validates_presence_of :title, :body
  
  validate  :uniqueness_of_new_permalink

  
  def tagstring
    tags.map { |t| t.name.strip.camelize }.sort.join(", ")
  end
  
  def tagstring=(newstring)
    if self.new_record?
      @save_tags = newstring.chomp
    else
      logger.info("\n*** STORING TAGS")
      self.tags.delete_all
      logger.info("\n*** old tags deleted")
      newstring.split(",").sort.uniq.each do |t|
        logger.info("\n*** Add tag #{t} to #{id}")
        self.tags.create( :tagable_id => id, :tagable_type => self.class.to_s, :name => t.strip.camelize )
      end
    end
  end  
  
  def new_permalink=(newlink)
    newlink.chomp!
    if Permalink.find_by_url(newlink)
      @permalink_exists_error = true
    else
      @new_permalink = newlink
    end
  end
  
  def group_restrictions=(restrictions)
    @restrictions_to_save = restrictions
  end
  
  def allowed_users
    if group_restrictions.empty? && self.draft == false
      logger.info("\n** ALLOW PUBLIC ACCESS TO #{self.title}")
      return true
    end
    rc = [ self.user ]
    unless self.draft == true
      rc << group_restrictions.map(&:usergroup).map { |grp| grp.members}.flatten
    end
    logger.info("\n** ALLOW ACCESS TO #{self.title} TO #{rc.flatten.uniq.map(&:username).join(",")}\n")
    return rc.flatten.uniq
  end
  
  # short title for lists and callback for ...ables
  def list_title(n=40)
    st = title[0..n].to_s
    st += "..." unless title.length <= n
    st
  end
  
  def prefixed_title
    ancestors.any? ? ancestors.map(&:title).join(' > ')+' > '+title : title
  end
  
  def self.tree(page)
    tree_items = []
    roots.each do |pg|
      tree_items << pg
      tree_items << parent_select(pg,tree_items)
    end
    tree_items.flatten.uniq.reject { |r| r == page || page.ancestors.include?(r)}
  end
  
  def self.parent_select(page,parents)
    for child in page.children do
      parents << child
      parents << parent_select(child,parents)
    end
  end
  
  # TODO: Check if user allowed to read this posting
  # This callback is used by tagables and therefor it is defined as this simple placeholder yet
  def read_allowed?(user)
    return true unless self.group_restrictions.any?
    return false unless user
    group_restrictions.each do |r|
      unless user.group_memberships.find_by_usergroup_id(r.usergroup.id).nil?
        logger.info("\n**** GRANT ACCESS TO GROUP #{r.usergroup.name}")
        return true
      end
    end
    return false
  end
  
  def rss_body
    body.to_s
  end
  
  private
  
  def add_new_permalinks
    unless @new_permalink.blank?
      pl = self.permalinks.build(:url => @new_permalink)
      self.permalink_ids << pl
    end
  end
  
  def assign_tags
    if @save_tags
      self.tagstring=(@save_tags)
    end
  end
  
  def uniqueness_of_new_permalink
    if @permalink_exists_error
      self.errors.add( :new_permalink, t(:permalink_exists))
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

