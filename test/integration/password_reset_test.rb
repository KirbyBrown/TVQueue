require 'test_helper'

class ResetPasswordTest < ActionDispatch::IntegrationTest


  setup do
    @user = users(:one)
  end

  test "reset user's password" do
    old_password = @user.encrypted_password
    reset_password_token = @user.send_reset_password_instructions
    @user.reload

    # Check that a token has been generated
    assert_not_nil @user.reset_password_token

    # Ensure that user can access the password reset screen
    get "http://tvq.ninja/users/password/edit?reset_password_token=#{@user.reset_password_token}"
    assert_select "input:match('id', ?)", "user_reset_password_token"

    # Ensure that a bad token won't reset the password
    put "/users/password", :params => { :user => {
      reset_password_token: "bad reset token",
      password: "new-password",
      password_confirmation: "new-password"
    }}
    assert_match "error", response.body
    assert_equal @user.encrypted_password, old_password

    # Update password
    put "/users/password", :params => { :user => {
      reset_password_token: reset_password_token,
      password: "new-password",
      password_confirmation: "new-password"
    }}

    # After password update, signed in and redirected to root path
    assert_redirected_to root_path

    # Reload user and ensure that the password is updated
    @user.reload
    assert_not_equal(@user.encrypted_password, old_password)
  end

end
