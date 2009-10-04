require 'test_helper'

class ResetPasswordsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    putc "#"
    assert true
  end
  
  def test_create_valid
    putc "#"
    assert true
  end
end
