class ActionContextsController < ApplicationController
  def index
    params[:user_id] ||= current_user.id
    @user = User.find(params[:user_id])
    @search = @user.action_contexts.search(params[:search])
    @action_contexts = @search.all.paginate( :page => params[:page], :per_page => 15)
  end

  def show
  end

end
