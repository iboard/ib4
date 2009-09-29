require 'test_helper'

class PostingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Posting.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Posting.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Posting.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to posting_url(assigns(:posting))
  end
  
  def test_edit
    get :edit, :id => Posting.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Posting.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Posting.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Posting.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Posting.first
    assert_redirected_to posting_url(assigns(:posting))
  end
  
  def test_destroy
    posting = Posting.first
    delete :destroy, :id => posting
    assert_redirected_to postings_url
    assert !Posting.exists?(posting.id)
  end
end
