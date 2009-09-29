require 'test_helper'

class PostingTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Posting.new.valid?
  end
end
