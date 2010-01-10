class ProjectTask < ActiveRecord::Base
  belongs_to :project
  acts_as_tree
  validates_presence_of :name
  delegate :members, :to => :project
  
  TASK_STATES = [:new,:active,:paused,:done,:canceled]
  
  def self.states
    TASK_STATES.map(&:to_sym)
  end
  
end
