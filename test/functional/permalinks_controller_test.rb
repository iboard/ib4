require 'test_helper'

class PermalinksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Permalink.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Permalink.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Permalink.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to permalink_url(assigns(:permalink))
  end
  
  def test_edit
    get :edit, :id => Permalink.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Permalink.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Permalink.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Permalink.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Permalink.first
    assert_redirected_to permalink_url(assigns(:permalink))
  end
  
  def test_destroy
    permalink = Permalink.first
    delete :destroy, :id => permalink
    assert_redirected_to permalinks_url
    assert !Permalink.exists?(permalink.id)
  end
end
