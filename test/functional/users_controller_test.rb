require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_new
    puts "*"
    assert true
  end
  
  def test_create_invalid
    puts "*"
    assert true
  end
  
  def test_create_valid
    puts "*"
    assert true
  end
  
  def test_edit
    get :edit, :id => User.first
    assert_redirected_to login_path
  end
  
  def test_update_invalid
    get :edit, :id => User.first
    assert_redirected_to login_path
  end
  
  def test_update_valid
    get :edit, :id => User.first
    assert_redirected_to login_path
  end
end
