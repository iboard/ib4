require 'test_helper'

class NewsletterTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Newsletter.new.valid?
  end
end
