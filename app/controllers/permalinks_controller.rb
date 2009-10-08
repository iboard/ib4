class PermalinksController < ApplicationController
  
  before_filter   :require_owner_or_admin, :except => :show
  
  def index
    @permalinks = Permalink.all
  end
  
  def show
    @permalink = Permalink.find_by_url(params[:id])
    if @permalink
      redirect_to @permalink.linkable
    else
      redirect_to root_path
    end
  end
  
  def new
    @permalink = Permalink.new
  end
  
  def create
    @permalink = Permalink.new(params[:permalink])
    if @permalink.save
      flash[:notice] = "Successfully created permalink."
      redirect_to @permalink
    else
      render :action => 'new'
    end
  end
  
  def edit
    @permalink = Permalink.find(params[:id])
  end
  
  def update
    @permalink = Permalink.find(params[:id])
    if @permalink.update_attributes(params[:permalink])
      flash[:notice] = "Successfully updated permalink."
      redirect_to @permalink
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @permalink = Permalink.find(params[:id])
    linkable = @permalink.linkable

    @permalink.destroy
    flash[:notice] = "Successfully destroyed permalink."
    redirect_to :controller => linkable.class.to_s.downcase.pluralize, :action => :edit, :id => linkable
  end
  
  private
  def require_owner_or_admin
    @permalink = Permalink.find(params[:id])
    if !current_user || (@permalink.linkable.user != current_user && !current_user.is_admin?)
      flash[:error] = t(:access_denied_edit)
      redirect_to :controller => linkable.class.to_s.downcase.pluralize, :action => :edit, :id => linkable
    end
  end
  
end
