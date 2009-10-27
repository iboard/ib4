class CreateNewsletterIssues < ActiveRecord::Migration
  def self.up
    create_table :newsletter_issues do |t|
      t.integer :newsletter_id
      t.string :subject
      t.text :body
      t.datetime :queued_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :newsletter_issues
  end
end
