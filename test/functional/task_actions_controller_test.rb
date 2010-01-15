require 'test_helper'

class TaskActionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => TaskAction.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    TaskAction.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    TaskAction.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to task_action_url(assigns(:task_action))
  end
  
  def test_edit
    get :edit, :id => TaskAction.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    TaskAction.any_instance.stubs(:valid?).returns(false)
    put :update, :id => TaskAction.first
    assert_template 'edit'
  end
  
  def test_update_valid
    TaskAction.any_instance.stubs(:valid?).returns(true)
    put :update, :id => TaskAction.first
    assert_redirected_to task_action_url(assigns(:task_action))
  end
  
  def test_destroy
    task_action = TaskAction.first
    delete :destroy, :id => task_action
    assert_redirected_to task_actions_url
    assert !TaskAction.exists?(task_action.id)
  end
end
