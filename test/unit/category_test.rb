require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Category.new(:name => 'Cat1').valid?
  end
end
