require 'test_helper'

class NetworkTest < ActiveSupport::TestCase

  def setup
    @network = Network.new(tmdb_id: 1)
  end

  test "should be valid" do
    assert @network.valid?
  end

  test "tmdb_id should be present" do
    @network.tmdb_id = nil
    assert_not @network.valid?
  end

end
