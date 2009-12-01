# File        categories_controller.rb
# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
#
# Categories can be attached to 'Categorizables' (eg. Postings, ...)
class CategoriesController < ApplicationController
  
  # Categories accessable by admin-users only
  before_filter :require_admin, :except => [:show,:index]
  caches_action :index
  after_filter  :clear_cache, :only => [:create,:update,:destroy]
  
  def index
    @categories = Category.ascend_by_name.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
  end
  
  # Show this category and all records of categorizable models
  # TODO: You have to append new categorizable models like Posting which is the only model yet.
  def show
    if params[:id].to_i < 1
      pl = Permalink.find_by_url(params[:id])
      @category = pl ? pl.linkable : Category.first
    else
      @category = Category.find(params[:id])
    end
    # Fetch Postings
    @items = @category.categorizables.descend_by_updated_at.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
    # Append other 'categorizable' models to @items here...
  end
  
  def new
    @category = Category.new
  end
  
  def create
    params[:category]['permalink_ids'] ||= []
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to @category
      return false
    end
    render :action => 'new'
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    params[:category]['permalink_ids'] ||= []
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])      
      flash[:notice] = "Successfully updated category."
      redirect_to @category
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destroyed category."
    redirect_to categories_url
  end
  
  private
  def clear_cache
    clear_category_cache
  end
end
