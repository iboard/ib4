require 'test_helper'

class MessageNotificationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert MessageNotification.new.valid?
  end
end
