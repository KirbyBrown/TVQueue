class UsersController < ApplicationController

  def create
    @user = User.new(user_params)
    if @user.save
      send_activation_email(@user)
    end
  end
end
