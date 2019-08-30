class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, Badge
    @user = User.find(params[:user_id])
    @badges = @user.badges 
  end

end
