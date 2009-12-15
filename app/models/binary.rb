class Binary < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title
  validates_presence_of :description
  
  before_destroy :remember_file
  after_destroy :remove_file
  
  after_save    :save_file

  ACCESS_ROLES = [:private,:friends,:public]
  
  def uploaded_file=(file)
    if file
      @oldfilename   =  path
      self.filename  =  file.original_filename.gsub(/\s+/,"_").downcase
      self.mime_type = file.content_type
      self.filesize  = file.size
      @data          = file.read
    end
  end
    
  def path
    "#{RAILS_ROOT}/userfiles/#{sprintf("%08x",user ? user.id : 0)}/#{filename}"
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
    logger.info("\n**** SEARCH IN FRIENDS #{rc.inspect}")
    rc
  end
  
  def access_mask_ids=(mask_ids)
    self.access_mask = 0
    mask_ids.each do |i|
      self.access_mask += (2**ACCESS_ROLES.index(i[0].to_sym)) if i[1] == "1"
    end
  end
      
  private
  def get_or_create_path
    if ! File::exist?(File::dirname(path))
      logger.info("\n**CREATING PATH TO #{path}\n")
      Dir::mkdir(File::dirname(path))
    end
    path
  end
  
  def save_file
    return unless @data
    File::unlink(@oldfilename) if File::exist?(@oldfilename)
    f = File.open(get_or_create_path,'w')
    f << @data
    f.close
  end

  def remember_file
    @remove_filename = path
  end
  
  def remove_file
    File::unlink(@remove_filename) if @remove_filename
  end  
  
end
