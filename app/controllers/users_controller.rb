class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    # Display user profile
  end

  def edit
    # Edit user profile
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to root_path, alert: 'You can only edit your own profile.' unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:name, :city, :profile_picture)
  end
end
