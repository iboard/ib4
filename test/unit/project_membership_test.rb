require 'test_helper'

class ProjectMembershipTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ProjectMembership.new.valid?
  end
end
