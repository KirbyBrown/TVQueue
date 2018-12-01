require 'test_helper'

class NavbarTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    sign_in(@user, '123greetings')
  end

  # Currently tests that there is a navbar brand and that there is a link to the root route
  # Needs to be updated to make sure that they are one and the same
  test "brand in navbar should link to root route" do
    get root_path
    assert_select "a:match('class', ?)", 'navbar-brand'
    assert_select "a:match('href', ?)", '/'
  end

  test "link to help page should be displayed on nav bar" do
    get root_path
    assert_select 'li', "Help"
    assert_select "a:match('href', ?)", /static_pages\/help/
  end

  test "link to 'Manage Shows' should be displayed on nav bar" do
    get root_path
    assert_select 'li', "Manage Shows"
    assert_select "a:match('href', ?)", /tv_shows\/index/
  end

end
