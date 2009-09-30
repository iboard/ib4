require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Tag.new.valid?
  end
end
