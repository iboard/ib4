class Project < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :page
  has_many :project_memberships, :dependent => :delete_all
  has_many :members, :through => :project_memberships, :source => :user
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id

  has_many     :group_restrictions, :as => :restrictable, :dependent => :destroy


  ACCESS_ROLES = [:private,:friends,:public]
  PROJECT_STATI= [:new,:busy,:paused,:finished,:canceled]

  after_create :assign_restrictions, :assign_members
  after_save   :assign_restrictions, :assign_members


  def project_member_ids=(new_members)
    @project_members = new_members
  end
  
  def list_title(len)
    name
  end
  
  def possible_access_roles
    ACCESS_ROLES
  end
    
  def accessable_by?(role)
    (access_mask && !(self.access_mask & 2**ACCESS_ROLES.index(role)).zero?)
  end
  
  def access_roles
    ACCESS_ROLES.reject {|r| ( (access_mask||0) & 2**ACCESS_ROLES.index(r)).zero? }.map(&:to_s)
  end
  
  def friends_access
    if accessable_by?( :friends ) 
      rc = user.commited_friendships.map{|m| [m.user, m.friend] }.flatten.uniq
    else
      rc = [user]
    end
    rc
  end
  
  def access_mask_ids=(mask_ids)
    self.access_mask = 0
    mask_ids.each do |i|
      self.access_mask += (2**ACCESS_ROLES.index(i[0].to_sym)) if i[1] == "1"
    end
  end
  
  def status_as_string
    if status
      PROJECT_STATI[status].to_s.humanize
    else
      t(:unstated)
    end
  end
  
  def group_restrictions=(restrictions)
    @restrictions_to_save = restrictions
  end
    
  def allowed_users
    if group_restrictions.empty?
      if accessable_by?(:public)
        return User.ascend_by_fullname.all 
      end
      if accessable_by?(:friends)
        return user.my_friends
      end
    else
      [ user, group_restrictions.map(&:usergroup).map { |grp| grp.members}.flatten ].flatten.uniq
    end
  end

  def assign_restrictions
      group_restrictions.delete_all
      if @restrictions_to_save
        @restrictions_to_save.each do |r|
          x = group_restrictions.create( :usergroup_id => r[0].to_i )
        end
      end
  end

  private
  def assign_members
    project_memberships.delete_all
    if @project_members
      @project_members.each do |member|
         project_memberships.create(:user_id => member[0].to_i)
      end
    end
  end  
end
