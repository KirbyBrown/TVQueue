class EmailConfirmationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.confirmed? && user.authenticated?(:confirmation, params[:id])
      user.activate
      redirect_to root_url
      flash[:success] = "Email confirmed!"
    else
      flash[:danger] = "Invalid email confirmation link"
      redirect_to root_url
    end
  end
end
