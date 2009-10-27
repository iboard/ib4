class CreateNewsletterBlacklists < ActiveRecord::Migration
  def self.up
    create_table :newsletter_blacklists do |t|
      t.string :mail

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_blacklists
  end
end
