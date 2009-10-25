class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = t(:friendship_added)
      redirect_to users_path
    else
      flash[:error] = t(:friendship_not_added)
      redirect_to users_path
    end
  end
  
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = t(:friendship_successfully_destroyed)
    redirect_to current_user
  end
end
