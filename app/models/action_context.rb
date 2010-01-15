class ActionContext < ActiveRecord::Base
  belongs_to  :task_action
  has_one     :user, :through => :task_action
  has_one     :project, :through => :task_action
end
