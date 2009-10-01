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
  
  def index
    @categories = Category.ascend_by_name.paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)
  end
  
  # Show this category and all records of categorizable models
  # TODO: You have to append new categorizable models like Posting which is the only model yet.
  def show
    @category = Category.find(params[:id])
    
    # Fetch Postings
    @items = @category.categorizables.categorizable_type_is('Posting').paginate(:page => params[:page], :per_page => POSTINGS_PER_PAGE)

    # Append other 'categorizable' models to @items here...
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category."
      redirect_to @category
    else
      render :action => 'new'
    end
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
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
end
