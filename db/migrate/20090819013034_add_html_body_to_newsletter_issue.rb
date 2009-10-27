class AddHtmlBodyToNewsletterIssue < ActiveRecord::Migration
  def self.up
    add_column "newsletter_issues", "html_body", :text
  end

  def self.down
    remove_column "newsletter_issues", "html_body"
  end
end
