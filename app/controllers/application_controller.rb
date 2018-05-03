class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def add_or_update_show(show)
    if show.updated_at.nil? || show.updated_at < (Time.now - 24.hours)
      response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
      tmdb_show_data = JSON.parse(response)
      show.title = tmdb_show_data["name"]
      show.number_of_seasons = tmdb_show_data["number_of_seasons"]
      show.save
      show.touch
    end
  end

  def add_episodes(show)
    number_of_seasons = show.number_of_seasons
    number_of_seasons.times do |season|
      season_number = season + 1
      response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}/season/#{season_number}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
      episodes = JSON.parse(response)
      number_of_episodes = episodes["episodes"].count
      number_of_episodes.times do |episode|
        new_episode = Episode.find_or_create_by(tv_show: show, season: season_number, episode_number: episodes["episodes"][episode]["episode_number"], airdate: episodes["episodes"][episode]["air_date"].to_date, title: episodes["episodes"][episode]["name"])
        new_episode.save
        new_episode.touch
      end
    end
  end

  def queue_episodes(show)
    show.episodes.each do |episode_to_queue|
      queued_episode = QueuedEpisode.create(episode: episode_to_queue, user: current_user)
    end
  end

end
