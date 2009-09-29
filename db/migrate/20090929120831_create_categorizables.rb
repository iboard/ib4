class CreateCategorizables < ActiveRecord::Migration
  def self.up
    create_table :categorizables do |t|
      t.integer :category_id
      t.integer :categorizable_id
      t.string  :categorizable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :categorizables
  end
end
