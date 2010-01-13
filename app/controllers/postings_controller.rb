# File        postings_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
#
# Postings belogs to a user and can have one or more categories as a 'categorizable'
class PostingsController < ApplicationController

  before_filter   :require_user, :only => [:new, :edit, :create, :update, :destroy]
  before_filter   :require_owner_or_admin, :only => [:edit,:update,:destroy]
  after_filter    :clear_cache, :only => [:create,:update,:destroy]
  
  filter_resource_access
  
  
  # If a category_id is given postings are restricted to the given category.
  # If no category_id is given postings are searched with searchlogic
  def index
    if params[:category_id]
      # fetch postings of this category only...
      @category = Category.find(params[:category_id])
      @postings = @category.categorizables.find_all_by_categorizable_type('Posting',
         :conditions => ['draft = ? OR user_id = ?', false, current_user]
         ).reject {|r| !r.read_allowed?(current_user) }.map(&:categorizable).paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
    else
      # fetch postings of all categories
      if params[:user_id]
        # fetch postings of the given user only
        @user = User.find(params[:user_id],:include  => :postings)
        @postings = @user.postings.descend_by_updated_at(
           :conditions => ['draft = ? OR user_id = ?', false, current_user]).reject {|r| !r.read_allowed?(current_user) }.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
      else
        # fetch all postings in all categories of each user matching the searchlogic
        unless params[:search].blank?
          @postings = Posting.subject_like_any_or_body_like_any(
                        params[:search].split(/[\s|,]+/),
                           :conditions => ['draft is ? OR user_id = ?', false, current_user]
                      ).descend_by_updated_at.reject {|r| !r.read_allowed?(current_user) }.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
        else
          # fetch ALL postings
          @postings = Posting.descend_by_updated_at(:include => [:comments,:permalinks,:tags,:user]).reject {|r| !r.read_allowed?(current_user) }.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE,
             :conditions => ['draft = ? OR user_id = ?', false, current_user] )
        end
      end
    end
  end
  
  
  def show
    @posting = Posting.find(params[:id])
  end
  
  def new
    @posting = Posting.new
  end
  
  def create
    params[:posting]['category_ids'] ||= []
    @posting = Posting.new(params[:posting])
    @posting.user ||= current_user
    if @posting.save
      flash[:notice] = "Successfully created posting."
      redirect_to @posting
    else
      render :action => 'new'
    end
  end
  
  def edit
    @posting ||= Posting.find(params[:id])
  end
  
  def update
    params[:posting]['category_ids'] ||= []    
    @posting ||= Posting.find(params[:id])
    if @posting.update_attributes(params[:posting])
      flash[:notice] = "Successfully updated posting."
      redirect_to @posting
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @posting ||= Posting.find(params[:id])
    @posting.destroy
    flash[:notice] = "Successfully destroyed posting."
    redirect_to postings_url
  end
  
  private
  def require_owner_or_admin
    @posting ||= Posting.find(params[:id])
    unless is_owner_or_admin?(@posting)
      flash[:error] = t(:access_denied_edit)
      render :show
    end
  end
  
  def clear_cache
    clear_tags_cache
    clear_category_cache
  end
  
end
