class CreateActionContexts < ActiveRecord::Migration
  def self.up
    create_table :action_contexts do |t|
      t.string :name
      t.integer :task_action_id
      t.timestamps
    end
  end

  def self.down
    drop_table :action_contexts
  end
end
