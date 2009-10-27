class NewsletterSubscriptionsController < ApplicationController
  
  before_filter :load_newsletter

  def index
    @newsletter_subscriptions = @newsletter.newsletter_subscriptions
  end

  def new
    @newsletter_subscription = @newsletter.build_newsletter_subscription.new(params[:newsletter_subscription])
  end
  
  def edit
    @newsletter_subscription = @newsletter.newsletter_subscriptions.find(params[:id])
  end
  
  def update
    @newsletter_subscription = @newsletter.newsletter_subscriptions.find(params[:id])
  end

  def create
    @newsletter_subscription = @newsletter.newsletter_subscriptions.build(params[:newsletter_subscription])
    
    addresses = params[:newsletter_subscription][:mail].split(/[,|\s|;]/).reject { |x| x.blank? }
    
    if addresses.length == 1
      @newsletter_subscription = @newsletter.newsletter_subscriptions.build(params[:newsletter_subscription])
    else
      params[:mode] += "_BULK"
    end
    
    case params[:mode]
    when 'add_BULK'
      cnt_before = @newsletter.newsletter_subscriptions.count
      addresses.each do |addr|
        @newsletter.newsletter_subscriptions.create(:mail => addr) if NewsletterBlacklist.find_by_mail(addr).nil?
      end
      flash[:notice] = "Added #{@newsletter.newsletter_subscriptions.count-cnt_before} new addresses."
      redirect_to newsletter_newsletter_subscriptions_path(@newsletter)
      return false
    when 'remove_BULK'
      subs = @newsletter.newsletter_subscriptions.find_all_by_mail(addresses)
      flash[:notice] = "Removing"
      subs.each do |s|
        s.destroy
      end
      redirect_to newsletter_newsletter_subscriptions_path(@newsletter)
      return false
    when 'add'
      respond_to do |format|
         if @newsletter_subscription.save
           flash[:notice] = 'newsletter_subscription was successfully created.'
           format.html { redirect_to( newsletter_newsletter_subscriptions_path(@newsletter)) }
           format.xml  { render :xml => @newsletter_subscription, :status => :created, :location => @newsletter_subscription }
         else
           format.html { render :action => "new" }
           format.xml  { render :xml => @newsletter_subscription.errors, :status => :unprocessable_entity }
         end
      end  
      return false
    when 'remove'
      subscription = @newsletter.newsletter_subscriptions.find_by_mail(params[:newsletter_subscription][:mail])
      if subscription
        subscription.delete
        redirect_to newsletter_newsletter_subscriptions_path(@newsletter)
        return false
      else
        flash[:error] = t(:subscription_not_found)
      end
    else
      flash[:notice] = "Unknown Mode in #{__FILE__}, #{__LINE__}, #{params[:mode]}"
    end
    render :action => "new"
  end

  def destroy
    @newsletter_subscription = @newsletter.newsletter_subscriptions.find(params[:id])
    @newsletter_subscriptions.destroy
    flash[:notice] = t(:subscription_destroyed)
    redirect_to @newsletter
  end


  private
  def load_newsletter
    @newsletter = Newsletter.find(params[:newsletter_id])
  end
end
