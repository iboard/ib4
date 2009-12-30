require 'test_helper'

class UsergroupsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Usergroup.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Usergroup.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Usergroup.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to usergroup_url(assigns(:usergroup))
  end
  
  def test_edit
    get :edit, :id => Usergroup.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Usergroup.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Usergroup.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Usergroup.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Usergroup.first
    assert_redirected_to usergroup_url(assigns(:usergroup))
  end
  
  def test_destroy
    usergroup = Usergroup.first
    delete :destroy, :id => usergroup
    assert_redirected_to usergroups_url
    assert !Usergroup.exists?(usergroup.id)
  end
end
