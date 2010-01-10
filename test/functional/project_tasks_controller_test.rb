require 'test_helper'

class ProjectTasksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => ProjectTask.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    ProjectTask.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    ProjectTask.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to project_task_url(assigns(:project_task))
  end
  
  def test_edit
    get :edit, :id => ProjectTask.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    ProjectTask.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ProjectTask.first
    assert_template 'edit'
  end
  
  def test_update_valid
    ProjectTask.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ProjectTask.first
    assert_redirected_to project_task_url(assigns(:project_task))
  end
  
  def test_destroy
    project_task = ProjectTask.first
    delete :destroy, :id => project_task
    assert_redirected_to project_tasks_url
    assert !ProjectTask.exists?(project_task.id)
  end
end
