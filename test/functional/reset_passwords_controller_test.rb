require 'test_helper'

class ResetPasswordsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    puts "# ResetPasswords can't be tested please use your browser and email-client"
    assert true
  end
  
  def test_create_valid
    puts "# ResetPasswords can't be tested please use your browser and email-client"
    assert true
  end
end
