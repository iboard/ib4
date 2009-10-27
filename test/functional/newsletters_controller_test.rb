require 'test_helper'

class NewslettersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Newsletter.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Newsletter.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Newsletter.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to newsletter_url(assigns(:newsletter))
  end
  
  def test_edit
    get :edit, :id => Newsletter.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Newsletter.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Newsletter.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Newsletter.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Newsletter.first
    assert_redirected_to newsletter_url(assigns(:newsletter))
  end
  
  def test_destroy
    newsletter = Newsletter.first
    delete :destroy, :id => newsletter
    assert_redirected_to newsletters_url
    assert !Newsletter.exists?(newsletter.id)
  end
end
