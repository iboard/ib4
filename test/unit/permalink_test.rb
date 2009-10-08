require 'test_helper'

class PermalinkTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Permalink.new.valid?
  end
end
