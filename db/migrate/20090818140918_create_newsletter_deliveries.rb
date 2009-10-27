class CreateNewsletterDeliveries < ActiveRecord::Migration
  def self.up
    create_table :newsletter_deliveries do |t|
      t.integer :newsletter_subscription_id
      t.integer :newsletter_issue_id
      t.datetime :delivered_at

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_deliveries
  end
end
