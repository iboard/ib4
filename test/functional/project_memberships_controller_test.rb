require 'test_helper'

class ProjectMembershipsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => ProjectMembership.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    ProjectMembership.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    ProjectMembership.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to project_membership_url(assigns(:project_membership))
  end
  
  def test_edit
    get :edit, :id => ProjectMembership.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    ProjectMembership.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ProjectMembership.first
    assert_template 'edit'
  end
  
  def test_update_valid
    ProjectMembership.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ProjectMembership.first
    assert_redirected_to project_membership_url(assigns(:project_membership))
  end
  
  def test_destroy
    project_membership = ProjectMembership.first
    delete :destroy, :id => project_membership
    assert_redirected_to project_memberships_url
    assert !ProjectMembership.exists?(project_membership.id)
  end
end
