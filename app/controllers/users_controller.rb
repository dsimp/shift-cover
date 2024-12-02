# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]
  before_action :set_current_user, only: [:edit, :update]
  # You can remove the :correct_user before_action if @user is always current_user

  def show
    # @user is set by set_user
  end

  def edit
    # @user is set by set_current_user (current_user)
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

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :location, :profile_picture)
  end
end
