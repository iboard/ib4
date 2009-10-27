class AddFailureToNewsletterSubscription < ActiveRecord::Migration
  def self.up
    add_column "newsletter_deliveries", "failure_messages", :text
  end

  def self.down
    remove_column "newsletter_deliveries", "failure_messages"
  end
end
