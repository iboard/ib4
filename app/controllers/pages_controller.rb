class PagesController < ApplicationController
  
  before_filter   :find_permalink, :only => [:show]
  filter_access_to :all, :attribute_check => true, :load_method => lambda { 
    if params[:id]
      @page = Page.find(params[:id])
    else
      @page = Page.new
    end
  }
  after_filter    :clear_cache, :only => [:create,:update,:destroy]
    
  def index
    if params[:category_id]
      # fetch postings of this category only...
      @category = Category.find(params[:category_id])
      @pages = @category.categorizables.find_all_by_categorizable_type('Page', 
         :conditions => ['draft = ? OR user_id = ?', false, current_user]).map(&:categorizable).reject {|r| 
           !r.read_allowed?(current_user)}.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
    else
      # fetch postings of all categories
      if params[:user_id]
        # fetch postings of the given user only
        @user = User.find(params[:user_id])
        @pages = @user.pages.descend_by_updated_at.reject {|r| !r.read_allowed?(current_user)}.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE, :conditions => ['draft = ? OR user_id = ?', false, current_user] )
      else
        # fetch all postings in all categories of each user matching the searchlogic
        unless params[:search].blank?
          @pages = Page.title_like_any_or_description_like_any_or_body_like_any(
                        params[:search].split(/[\s|,]+/)
                      ).descend_by_updated_at.reject {|r| !r.read_allowed?(current_user)}.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE, :conditions => ['draft = ? OR user_id = ?', false, current_user] )
        else
          # fetch ALL postings
          @pages = Page.descend_by_updated_at.reject {|r| !r.read_allowed?(current_user)}.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE, :conditions => ['draft = ? OR user_id = ?', false, current_user] )
        end
      end
    end  
  end
  
  def show
    @page.revert_to(params[:version].to_i) if params[:version]  
  end
  
  def new
    @page = Page.new(:user_id => current_user)
  end
  
  def create
     params[:page]['category_ids'] ||= []
     params[:page]['permalink_ids'] ||= []
     @page = Page.new(params[:page])
     @page.user ||= current_user
     if @page.save
       flash[:notice] = "Successfully created posting."
       redirect_to @page
     else
       render :action => 'new'
     end
  end
  
  def edit
  end
  
  def update
     params[:page]['category_ids'] ||= []    
     params[:page]['permalink_ids'] ||= []
     if @page.update_attributes(params[:page])
       flash[:notice] = "Successfully updated posting."
       redirect_to @page
     else
       render :action => 'edit'
     end
  end
  
  def destroy
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to pages_url
  end
  
  def sort_roots
    params[:page_navigation_list].each_with_index do |id,index|
      Page.update_all(['position=?',index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
  def sort_children
    params[:page_subnavigation_list].each_with_index do |id,index|
      Page.update_all(['position=?',index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
  private
  def require_owner_or_admin
    unless is_owner_or_admin?(@page.user)
      flash[:error] = t(:access_denied_edit)
      render :show
    end
  end
  
  def clear_cache
    clear_tags_cache
    clear_category_cache    
  end
  
  def find_permalink
    if params[:id].to_i < 1
      pl = Permalink.find_by_url(params[:id])
      p = pl ? pl.linkable : Page.first
      params[:id] = p.id
    end
  end
  
end
