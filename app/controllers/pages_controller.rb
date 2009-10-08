class PagesController < ApplicationController
  
  before_filter   :require_user, :only => [:new, :edit, :create, :update, :destroy]
  before_filter   :require_owner_or_admin, :only => [:edit,:update,:destroy]
  
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
    @page = Page.find(params[:id])
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
    @page = Page.find(params[:id])
  end
  
  def update
     params[:page]['category_ids'] ||= []    
     params[:page]['permalink_ids'] ||= []
     @page ||= Page.find(params[:id])
     if @page.update_attributes(params[:page])
       flash[:notice] = "Successfully updated posting."
       redirect_to @page
     else
       render :action => 'edit'
     end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to pages_url
  end
  
  private
  def require_owner_or_admin
    @page ||= Page.find(params[:id])
    if @page.user != current_user && !current_user.is_admin?
      flash[:error] = t(:access_denied_edit)
      render :show
    end
  end
end
