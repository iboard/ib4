require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Note.new.valid?
  end
end
