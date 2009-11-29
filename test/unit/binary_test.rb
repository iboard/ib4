require 'test_helper'

class BinaryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Binary.new.valid?
  end
end
