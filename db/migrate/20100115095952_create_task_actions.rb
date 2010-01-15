class CreateTaskActions < ActiveRecord::Migration
  def self.up
    create_table :task_actions do |t|
      t.integer :project_task_id
      t.integer :user_id
      t.integer :context_string
      t.text :notice
      t.integer :state_flag
      t.timestamps
    end
  end
  
  def self.down
    drop_table :task_actions
  end
end
