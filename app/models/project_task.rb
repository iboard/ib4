class ProjectTask < ActiveRecord::Base
  belongs_to :project
  has_many   :task_actions, :dependent => :delete_all
  
  acts_as_tree :order => :position
  validates_presence_of :name
  delegate :members, :to => :project
  
  TASK_STATES = [:new,:active,:paused,:done,:canceled]
  
  
  def project_prefix
    project ? project.name.shorten(10,'~') + " > #{name}" : name.shorten(20,'~')
  end
  
  def self.states
    TASK_STATES.map(&:to_sym)
  end
  
  def state 
    TASK_STATES[state_mask].to_sym
  end
  def state?(s)
    i = TASK_STATES.index(s)
    return (state_mask == i)
  end
    
  def complete_map
    unless children.any?
      rc = TASK_STATES.map { |s| state_mask == TASK_STATES.index(s) ? 1 : 0 }
      rc << 1
      return rc
    end
    rc = []
    TASK_STATES.count+1.times { rc << 0 }
    children.each do |child|
      crc = child.complete_map
      crc.each_with_index do |r,i|
        rc[i] ||= 0
        rc[i] += r
      end
    end
    return rc
  end
  
end
