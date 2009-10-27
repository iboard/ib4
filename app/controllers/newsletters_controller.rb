class NewslettersController < ApplicationController
  
  before_filter  :require_admin, :except => [:subscriptions]
  
  def index
    @newsletters = Newsletter.all
  end
  
  def show
    @newsletter = Newsletter.find(params[:id])
  end
  
  def deliver_issue
    @newsletter = Newsletter.find(params[:id])
    @newsletter_issue = @newsletter.newsletter_issues.find(params[:newsletter_issue_id])
    @newsletter_deliveries = @newsletter.newsletter_deliveries || []
    render :layout => false
  end
  
  def new
    @newsletter = Newsletter.new
  end
  
  def create
    @newsletter = Newsletter.new(params[:newsletter])
    respond_to do |format|
      if @newsletter.save
        flash[:notice] = t(:newsletter_created)
        format.html { redirect_to(@newsletter) }
        format.xml  { render :xml => @newsletter, :status => :created, :location => @newsletter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @newsletter.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @newsletter = Newsletter.find(params[:id])
  end
  
  def update
    @newsletter = Newsletter.find(params[:id])
   respond_to do |format|
      if @newsletter.update_attributes(params[:newsletter])
        flash[:notice] = t(:newsletter_successfully_updated)
        format.html {           
          redirect_to(newsletter_path(@newsletter)) 
          }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @newsletter.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @newsletter = Newsletter.find(params[:id])
    @newsletter.destroy
    flash[:notice] = "Successfully destroyed newsletter."
    redirect_to newsletters_url
  end
  
  def subscriptions
    case params[:commit]
    when t(:check_to_block_your_mail_from_all_newsletters)
      block = NewsletterBlacklist.new(:mail => params[:mail])
      if block.save
        flash[:notice] = t(:address_blacklisted, :mail => decode64(params[:mail]))
        NewsletterSubscription.find_all_by_mail(decode64(params[:mail])).each do |s|
          s.destroy
        end
      else
        flash[:error] = block.errors.map{|e| e[0] + ": " + e[1]}.join("<br/>")
      end
    when t(:unsubscribe_text)
      msg = ""
      if  params[:subscription] && params[:subscription][:newsletters]
        params[:subscription][:newsletters].each_with_index do |newsletter,idx|
          subscription = NewsletterSubscription.find_by_newsletter_id_and_mail(newsletter,decode64(params[:mail]))
          if subscription 
            msg += "Remove newsletter subscription #{subscription.newsletter.title} (#{subscription.mail})<br/>"
            subscription.destroy
          end
        end
      else
        msg += t(:no_newsletters_selected)
      end
      flash[:notice] = msg
    end
    
    @newsletter_subscriptions = NewsletterSubscription.find_all_by_mail_and_token(
        decode64(params[:mail]), params[:token])
        
  end
end
