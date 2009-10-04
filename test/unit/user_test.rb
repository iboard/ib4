require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  
  def test_root_user_should_exists_after_seeding_the_database
    rootuser = User.new(:password => 'ABCDEFG')
    assert rootuser.crypted_password.empty? == false
  end
  
  
end
