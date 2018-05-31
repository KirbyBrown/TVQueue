require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    sign_in(@user, '123greetings')
  end

  test "link should be displayed on nav bar" do
    get root_path
    assert_select 'li', "Help"
    assert_select "a:match('href', ?)", /static_pages\/help/
  end

  test "should get help" do
    get static_pages_help_path
    assert_response :success
  end

  test "should display nav bar" do
    get static_pages_help_path
    assert_select 'nav'
  end

  test "should display help page" do
    get static_pages_help_path
    assert_select 'h1', "Help"
  end

end
