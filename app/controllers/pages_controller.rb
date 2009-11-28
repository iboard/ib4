class PagesController < ApplicationController
  
  before_filter   :find_permalink, :only => [:show]
  filter_resource_access
  after_filter    :clear_cache, :only => [:create,:update,:destroy]
    
  def index
    if params[:category_id]
      # fetch postings of this category only...
      @category = Category.find(params[:category_id])
      @pages = @category.categorizables.find_all_by_categorizable_type('Page').map(&:categorizable).paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
    else
      # fetch postings of all categories
      if params[:user_id]
        # fetch postings of the given user only
        @user = User.find(params[:user_id])
        @pages = @user.pages.descend_by_updated_at.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
      else
        # fetch all postings in all categories of each user matching the searchlogic
        unless params[:search].blank?
          @pages = Page.title_like_any_or_description_like_any_or_body_like_any(
                        params[:search].split(/[\s|,]+/)
                      ).descend_by_updated_at.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
        else
          # fetch ALL postings
          @pages = Page.descend_by_updated_at.paginate( :page => params[:page], :per_page => POSTINGS_PER_PAGE )
        end
      end
    end  
  end
  
  def show
    @page.revert_to(params[:version].to_i) if params[:version]  
  end
  
  def new
    @page = Page.new
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
