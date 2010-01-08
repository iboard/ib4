class CreateProjectMemberships < ActiveRecord::Migration
  def self.up
    create_table :project_memberships do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :role
      t.timestamps
    end
  end
  
  def self.down
    drop_table :project_memberships
  end
end
