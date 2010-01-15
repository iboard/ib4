require 'test_helper'

class TaskActionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert TaskAction.new.valid?
  end
end
