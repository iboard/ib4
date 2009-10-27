class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscriptions do |t|
      t.integer :newsletter_id
      t.string :mail
      t.string :token
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_subscriptions
  end
end
