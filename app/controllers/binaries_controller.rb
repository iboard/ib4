class BinariesController < ApplicationController
  
  before_filter  :load_user
  filter_resource_access
  
  def index
    @binaries = @user.binaries.reject {|b| 
      !( b.user == current_user || b.access_roles.include?('public') || b.friends_access && b.friends_access.include?(current_user))
    }.paginate( :page => params[:page], :per_page => BINARIES_PER_PAGE)
  end
  
  def show
    begin
      @binary = @user.binaries.find(params[:id])
      send_file( @binary.path, :type => @binary.mime_type, :disposition => (params[:download] ? 'attachment' : 'inline' ), :filename => @binary.filename )
    rescue 
      send_file( RAILS_ROOT + "/public" + FILE_NOT_FOUND_PATH, :type => 'image/png', 
                 :disposition => (params[:download] ? 'attachment' : 'inline' ), 
                 :filename => File::basename(FILE_NOT_FOUND_PATH) )
    end
    return false
  end
  
  def new
    @binary = @user.binaries.build
  end
  
  def create
    @binary = @user.binaries.build(params[:binary])
    if @binary.save
      flash[:notice] = "Successfully created binary."
      redirect_to user_binaries_path(@user)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @binary = @user.binaries.find(params[:id])
  end
  
  def update
    @binary = @user.binaries.find(params[:id])
    if @binary.update_attributes(params[:binary])
      flash[:notice] = "Successfully updated binary."
      redirect_to user_binaries_path(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @binary = @user.binaries.find(params[:id])
    @binary.destroy
    flash[:notice] = "Successfully destroyed binary."
    redirect_to user_binaries_path(@user)
  end
  
  private
  def load_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end
  
end
