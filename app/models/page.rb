class Page < ActiveRecord::Base
  belongs_to  :user                                                 # the user a posting was written by
  
  has_many    :categorizables, :as => :categorizable                # Jointable for categories
  has_many    :categories, :through => :categorizables              # Categories this posting belongs to
  
  has_many    :tags,     :as => :tagable, :dependent => :destroy    # Tags assigned to this posting
  
  has_many    :comments, :as => :commentable,                       # Comments for this posting
              :dependent => :destroy
              
  has_many    :permalinks, :as => :linkable,
              :dependent => :destroy
  
  after_create :assign_tags, :add_new_permalinks
  before_save  :add_new_permalinks
  after_save   :update_timestamps

  validates_presence_of :title, :body
  
  validate  :uniqueness_of_new_permalink

  
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
  
  def new_permalink=(newlink)
    if Permalink.find_by_url(newlink)
      @permalink_exists_error = true
    else
      @new_permalink = newlink
    end
  end
  
  # short title for lists and callback for ...ables
  def list_title(n=40)
    st = title[0..n].to_s
    st += "..." unless title.length <= n
    st
  end
  
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
end
