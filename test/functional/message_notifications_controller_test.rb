require 'test_helper'

class MessageNotificationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => MessageNotification.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    MessageNotification.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    MessageNotification.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to message_notification_url(assigns(:message_notification))
  end
  
  def test_edit
    get :edit, :id => MessageNotification.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    MessageNotification.any_instance.stubs(:valid?).returns(false)
    put :update, :id => MessageNotification.first
    assert_template 'edit'
  end
  
  def test_update_valid
    MessageNotification.any_instance.stubs(:valid?).returns(true)
    put :update, :id => MessageNotification.first
    assert_redirected_to message_notification_url(assigns(:message_notification))
  end
  
  def test_destroy
    message_notification = MessageNotification.first
    delete :destroy, :id => message_notification
    assert_redirected_to message_notifications_url
    assert !MessageNotification.exists?(message_notification.id)
  end
end
