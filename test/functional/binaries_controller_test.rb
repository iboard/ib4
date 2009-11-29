require 'test_helper'

class BinariesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Binary.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Binary.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Binary.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to binary_url(assigns(:binary))
  end
  
  def test_edit
    get :edit, :id => Binary.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Binary.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Binary.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Binary.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Binary.first
    assert_redirected_to binary_url(assigns(:binary))
  end
  
  def test_destroy
    binary = Binary.first
    delete :destroy, :id => binary
    assert_redirected_to binaries_url
    assert !Binary.exists?(binary.id)
  end
end
