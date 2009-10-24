require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Invitation.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Invitation.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Invitation.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to invitation_url(assigns(:invitation))
  end
  
  def test_edit
    get :edit, :id => Invitation.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Invitation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Invitation.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Invitation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Invitation.first
    assert_redirected_to invitation_url(assigns(:invitation))
  end
  
  def test_destroy
    invitation = Invitation.first
    delete :destroy, :id => invitation
    assert_redirected_to invitations_url
    assert !Invitation.exists?(invitation.id)
  end
end
