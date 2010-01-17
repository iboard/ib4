class TaskAction < ActiveRecord::Base
  belongs_to :project_task
  belongs_to :user
  has_many   :action_contexts, :dependent => :delete_all
  
  after_save :save_context_string
  after_create :save_context_string
  
  STATES = [:new,:accepted,:rejected,:done]
  
  def project
    @project ||= project_task.project if project_task
  end
  
  def context_strings=(new_context_strings)
    @save_context_strings = new_context_strings
  end
  
  def context_strings
    action_contexts.all.map(&:name).uniq
  end

  def context_strings_str=(new_context_strings)
    @save_context_strings = new_context_strings
  end
  
  def context_strings_str
    action_contexts.all.map(&:name).uniq.join(",")
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
    self.state_flag = STATES.index(state_sym.to_sym).inspect
  end
  
  
  private
  def save_context_string
    if @save_context_strings || @new_context_string
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
end
