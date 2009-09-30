require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Tag.first
    assert_template 'show'
  end
end
