require 'test_helper'

class QueuedEpisodeTest < ActiveSupport::TestCase

  def setup
    @tv_show = TvShow.create!(tmdb_id: 1, title: "Example Show", number_of_seasons: 1 )
    @episode = @tv_show.episodes.create!(season: 1, episode_number: 1, airdate: "9999-99-99", title: "Example Episode")
    @user = User.create!( email: "valid.user@example.com", password: "Test123" )

    @queued_episode = QueuedEpisode.new(user: @user, episode: @episode)
  end

  test "should be valid" do
    assert @queued_episode.valid?
  end

  test "user_id should be present" do
    @queued_episode.user_id = nil
    assert_not @queued_episode.valid?
  end

  test "episode_id should be present" do
    @queued_episode.episode_id = nil
    assert_not @queued_episode.valid?
  end

  test "combination of user_id and episode_id should be unique" do
    duplicate_queued_episode = @queued_episode.dup
    @queued_episode.save
    assert_not duplicate_queued_episode.valid?
  end

end
