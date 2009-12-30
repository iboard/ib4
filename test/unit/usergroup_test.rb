require 'test_helper'

class UsergroupTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Usergroup.new.valid?
  end
end
