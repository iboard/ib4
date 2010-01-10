class CreateProjectTasks < ActiveRecord::Migration
  def self.up
    create_table :project_tasks do |t|
      t.integer :parent_id
      t.integer :position
      t.integer :project_id
      t.string :name
      t.text :description
      t.integer :state_mask
      t.datetime :date_due
      t.integer :flag_mask
      t.timestamps
    end
  end
  
  def self.down
    drop_table :project_tasks
  end
end
