class NewsletterIssuesController < ApplicationController
  
  before_filter :load_newsletter, :except => [:deliver, :deliver_test]
  before_filter :require_admin, :except => [:index,:show]
  
  include ApplicationHelper
  
  def index
    @newsletter_issues = @newsletter.newsletter_issues.descend_by_updated_at
  end
  
  def show
    @newsletter_issue = @newsletter.newsletter_issues.find(params[:id],:include => [:newsletter_deliveries])
  end
  
  def deliver
    @newsletter_issue = NewsletterIssue.find(params[:id])
    @newsletter = @newsletter_issue.newsletter
    @newsletter_issue.queued_at = Time::now()
    @newsletter_issue.save!
    Delayed::Job.enqueue(
       NewsletterPostman.new(
         @newsletter_issue.id,
         @newsletter.title,
         @newsletter_issue.subject,
         ::ROOT_URL + @newsletter.banner.url(:default),        
         @newsletter.header,
         @newsletter.footer,
         @newsletter_issue.html_body,
         subscriptions_url("NEWSLETTER_EMAIL","TOKEN")
       )
    )
    render :layout => false
  end
  
  def deliver_test
    @newsletter_issue = NewsletterIssue.find(params[:id])
     @newsletter = @newsletter_issue.newsletter
     Delayed::Job.enqueue(
        NewsletterTestmailer.new(
          @newsletter_issue.id,
          @newsletter.title,
          @newsletter_issue.subject,
          ::ROOT_URL + @newsletter.banner.url(:default),
          @newsletter.header,
          @newsletter.footer,
          @newsletter_issue.html_body,
          subscriptions_url("NEWSLETTER_EMAIL","TOKEN")
        )
     )
     render :text => t(:test_sent), :layout => false
  end
  
  def new
    @newsletter_issue = @newsletter.newsletter_issues.build
  end
  
  def create
    @newsletter_issue = @newsletter.newsletter_issues.build(params[:newsletter_issue])
    params[:newsletter_issue][:html_body] = (params[:newsletter_issue][:body]).to_txt
    if @newsletter_issue.save
      flash[:notice] = "Successfully created newsletterissue."
      redirect_to newsletter_newsletter_issue_path(@newsletter,@newsletter_issue)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @newsletter_issue = @newsletter.newsletter_issues.find(params[:id])
  end
  
  def update
    @newsletter_issue = @newsletter.newsletter_issues.find(params[:id])
    params[:newsletter_issue][:html_body] = params[:newsletter_issue][:body].to_txt
    if @newsletter_issue.update_attributes(params[:newsletter_issue])
      flash[:notice] = "Successfully updated newsletterissue."
      redirect_to newsletter_newsletter_issue_path(@newsletter,@newsletter_issue)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @newsletter_issue = @newsletter.newsletter_issues.find(params[:id])
    @newsletter_issue.destroy
    flash[:notice] = "Successfully destroyed newsletterissue."
    redirect_to newsletter_newsletter_issues_path(@newsletter)
  end
  
  
  private
  def load_newsletter
    @newsletter = Newsletter.find(params[:newsletter_id])
  end
end
