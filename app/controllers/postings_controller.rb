# File        postings_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
#
# Postings belogs to a user and can have one or more categories as a 'categorizable'
class PostingsController < ApplicationController

  before_filter   :require_user, :only => [:new, :edit, :create, :update, :destroy]
  
  # If a category_id is given postings are restricted to the given category.
  # If no category_id is given postings are searched with searchlogic
  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @postings = @category.categorizables.find_all_by_categorizable_type('Posting').map(&:categorizable).paginate( :page => params[:page], :per_page => 2 )
    else
      if !params[:search].blank?
        @postings = Posting.subject_like_any_or_body_like_any(
                      params[:search].split(/[\s|,]+/)
                    ).descend_by_updated_at.paginate( :page => params[:page], :per_page => 2 )
      else
        @postings = Posting.descend_by_updated_at.paginate( :page => params[:page], :per_page => 2 )
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
    @posting = Posting.find(params[:id])
  end
  
  def update
    params[:posting]['category_ids'] ||= []    
    @posting = Posting.find(params[:id])
    if @posting.update_attributes(params[:posting])
      flash[:notice] = "Successfully updated posting."
      redirect_to @posting
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @posting = Posting.find(params[:id])
    @posting.destroy
    flash[:notice] = "Successfully destroyed posting."
    redirect_to postings_url
  end
end
