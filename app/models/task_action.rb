class TaskAction < ActiveRecord::Base
  belongs_to :project_task
  belongs_to :user
  has_many   :action_contexts, :dependent => :delete_all
  has_one    :project, :through => :project_task
  
  delegate   :date_due, :to => :project_task
  
  after_save :save_context_string
  after_create :save_context_string
  
  STATES = [:new,:accepted,:rejected,:done]
  
  def context_strings=(new_context_strings)
    @save_context_strings = new_context_strings
  end
  
  def context_strings
    action_contexts.all.map(&:name).uniq
  end
  
  def new_context_string
    ""
  end
  
  def new_context_string=(str)
    @new_context_string = str
  end
      
  def state
    STATES[state_flag||0].to_sym
  end
  
  def state=(state_sym)
    state_flag = STATES.index(state_sym)
  end
  
  
  private
  def save_context_string
    action_contexts.delete_all
    if @save_context_strings
      @save_context_strings.each do |c|
        action_contexts.create(:name => c.strip.humanize)
      end
    end
    if @new_context_string
      @new_context_string.split(/,; /).uniq.each do |a|
        action_contexts.create(:name => a.strip.humanize)
      end
    end
  end
end
