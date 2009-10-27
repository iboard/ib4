require 'test_helper'

class NewsletterIssueTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert NewsletterIssue.new.valid?
  end
end
