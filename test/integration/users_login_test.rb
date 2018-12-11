require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
  end

  test "must be logged in to access queue" do
    get tv_shows_index_path
    assert_select 'li', count: 0
    sign_in(@user, @user.password)
    assert_select 'li'
  end

  test "login with valid information" do
    get new_user_session_path
    post user_session_path, params: { user: { email:  @user.email, password: '123greetings' } }
    assert_redirected_to root_url
    follow_redirect!
    assert_response :success
    assert_template 'layouts/application'
    assert_template 'tv_shows/index'
    assert_select "aside", {count: 1, text: "Signed in successfully."}
  end

  test "reject login with wrong password" do
    get new_user_session_path
    post user_session_path, params: { user: { email: @user.email, password: 'wrong' } }
    assert_response :success
    assert_template 'layouts/application'
    assert_select "aside", { count: 1, text: "Invalid Email or password." }
  end

  test "reject login with wrong username" do
    get new_user_session_path
    post user_session_path, params: { user: { email: "bademail@example.com", password: @user.password } }
    assert_response :success
    assert_template 'layouts/application'
    assert_select "aside", { count: 1, text: "Invalid Email or password." }
  end

end
