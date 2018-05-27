require 'test_helper'

class TvShowTest < ActiveSupport::TestCase

  def setup
    @tv_show = TvShow.new(tmdb_id: 1, title: "Example Show", number_of_seasons: 1 )
  end

  test "should be valid" do
    assert @tv_show.valid?
  end

  test "tmdb_id should be present" do
    @tv_show.tmdb_id = nil
    assert_not @tv_show.valid?
  end

  test "tmdb_id should be unique" do
    duplicate_tv_show = @tv_show.dup
    @tv_show.save
    assert_not duplicate_tv_show.valid?
  end

  test "associated episodes should be destroyed" do
    @tv_show.save
    @tv_show.episodes.create!(season: 1, episode_number: 1, airdate: "9999-99-99", title: "Example Episode")
    assert_difference 'Episode.count', -1 do
      @tv_show.destroy
    end
  end

end
