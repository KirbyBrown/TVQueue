require 'test_helper'

class QueuedEpisodesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    sign_in(@user, '123greetings')
  end

  test "should get index" do
    get queued_episodes_index_path
    assert_response :success
  end

end
