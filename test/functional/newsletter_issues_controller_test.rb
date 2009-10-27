require 'test_helper'

class NewsletterIssuesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => NewsletterIssue.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    NewsletterIssue.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    NewsletterIssue.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to newsletter_issue_url(assigns(:newsletter_issue))
  end
  
  def test_edit
    get :edit, :id => NewsletterIssue.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    NewsletterIssue.any_instance.stubs(:valid?).returns(false)
    put :update, :id => NewsletterIssue.first
    assert_template 'edit'
  end
  
  def test_update_valid
    NewsletterIssue.any_instance.stubs(:valid?).returns(true)
    put :update, :id => NewsletterIssue.first
    assert_redirected_to newsletter_issue_url(assigns(:newsletter_issue))
  end
  
  def test_destroy
    newsletter_issue = NewsletterIssue.first
    delete :destroy, :id => newsletter_issue
    assert_redirected_to newsletter_issues_url
    assert !NewsletterIssue.exists?(newsletter_issue.id)
  end
end
