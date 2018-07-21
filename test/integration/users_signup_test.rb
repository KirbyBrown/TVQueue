require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post user_registration_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'devise/registrations/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with Email Confirmation" do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.confirmed?
    # Invalid confirmation token
    get edit_email_confirmation_path("invalid token", email: user.email, id: user.id)
    assert_not user.confirmed?
    # Valid token, wrong email
    get edit_email_confirmation_path(user.confirmation_token, email: 'wrong', id: user.id)
    assert_not user.confirmed?
    # Valid confirmation token
    get edit_email_confirmation_path(user.confirmation_token, email: user.email)
    assert user.reload.confirmed?
  end
end
