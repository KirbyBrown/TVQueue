class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def add_or_update_network(show)
    show = show
    unless show.network.nil?
      network = show.network
      if network.updated_at.nil? || network.updated_at == network.created_at || network.updated_at < (Time.now - 4.hours)
        response = open("https://api.themoviedb.org/3/network/#{network.tmdb_id}/images?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
        tmdb_network_images = JSON.parse(response)
        response = open("https://api.themoviedb.org/3/network/#{network.tmdb_id}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
        tmdb_network_data = JSON.parse(response)
        network.logo_path = tmdb_network_images["logos"][0]["file_path"]
        network.name = tmdb_network_data["name"]
        network.save
        network.touch

        show.network = network
        show.save
      end
    end
  end

  def add_or_update_show(show)
    if show.updated_at.nil? || show.updated_at < (Time.now - 4.hours)
      response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
      tmdb_show_data = JSON.parse(response)
      show.title = tmdb_show_data["name"]
      show.number_of_seasons = tmdb_show_data["number_of_seasons"]
      show.poster_path = tmdb_show_data["poster_path"]
      show.network = Network.find_or_create_by(tmdb_id: tmdb_show_data["networks"][0]["id"])
      show.save
      show.touch
    end
  end

  def add_or_update_episodes(show)
    if show.episodes.last.nil? || show.episodes.last.updated_at < (Time.now - 4.hours)
      number_of_seasons = show.number_of_seasons
      number_of_seasons.times do |season|
        season_number = season + 1
        response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}/season/#{season_number}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
        episodes = JSON.parse(response)
        number_of_episodes = episodes["episodes"].count
        number_of_episodes.times do |episode|
          new_episode = Episode.find_or_initialize_by(tv_show: show, season: season_number, episode_number: episodes["episodes"][episode]["episode_number"])
          new_episode.update(airdate: episodes["episodes"][episode]["air_date"].to_date, title: episodes["episodes"][episode]["name"], still_path: episodes["episodes"][episode]["still_path"])
          new_episode.save
          new_episode.touch
        end
      end
    end
  end

  def queue_episodes(show)
    show.episodes.each do |episode_to_queue|
      queued_episode = QueuedEpisode.create(episode: episode_to_queue, user: current_user)
    end
  end
end
