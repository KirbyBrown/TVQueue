require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase

  def setup
    @tv_show = TvShow.create!(tmdb_id: 1, title: "Example Show", number_of_seasons: 1 )
    @episode = @tv_show.episodes.new(season: 1, episode_number: 1, airdate: "9999-99-99", title: "Example Episode")
  end

  test "should be valid" do
    assert @episode.valid?
  end

  test "tv_show_id should be present" do
    @episode.tv_show_id = nil
    assert_not @episode.valid?
  end

  test "associated queued_episodes should be destroyed" do
    @episode.save
    @episode.queued_episodes.create!(user: users(:one))
    assert_difference 'QueuedEpisode.count', -1 do
      @episode.destroy
    end
  end

end
