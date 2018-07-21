class UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to confirm your email address."
    end
  end

  def send_verification_email
    @user = current_user
    @user.send_activation_email
    flash[:info] = "Please check your email to confirm your email address."
  end
end
