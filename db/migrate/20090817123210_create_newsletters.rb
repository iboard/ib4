class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :title
      t.string :reply_to
      t.integer :image_attachment_id   # The Banner
      t.text :header
      t.text :footer
      t.timestamps
    end
  end
  
  def self.down
    drop_table :newsletters
  end
end
