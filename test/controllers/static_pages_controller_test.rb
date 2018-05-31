require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    sign_in(@user, '123greetings')
  end

  test "should get help" do
    get static_pages_help_path
    assert_response :success
  end

end
