class AddPositionToTaskAction < ActiveRecord::Migration
  def self.up
    add_column :task_actions, :position, :integer
    add_column :task_actions, :date_due, :datetime
  end

  def self.down
    remove_column :task_actions, :position
    remove_column :task_actions, :date_due
  end
end
