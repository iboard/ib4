require 'test_helper'

class ProjectTaskTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ProjectTask.new.valid?
  end
end
