require 'open-uri'
class TvShowsController < ApplicationController
  before_action :authenticate_user!

  def search

  end

  def search_results
    @search_string = search_query_params
    @potential_show_data = search_for_show(@search_string)
    user_tv_show_ids = current_user.episodes.joins(:tv_show).map(&:tv_show_id).uniq
    @user_tv_show_tmdb_ids = TvShow.where(id: user_tv_show_ids).pluck(:tmdb_id)
#    @tv_show = TvShow.new
  end

  def add
    show_to_add = add_or_remove_show_params
    tv_show = TvShow.find_or_initialize_by(tmdb_id: show_to_add[:tmdb_id])
    add_or_update_show(tv_show)
    tv_show = TvShow.find_by(tmdb_id: show_to_add[:tmdb_id])
    add_or_update_episodes(tv_show)
    queue_episodes(tv_show)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { render 'tv_shows/update_search_results' }
    end
  end

  def remove
    tv_show_id_to_remove = add_or_remove_show_params[:tmdb_id]
    tv_show = TvShow.find_by(tmdb_id: tv_show_id_to_remove)
    episode_ids_to_dequeue = Episode.where(tv_show: tv_show).map(&:id)
    queued_episodes_to_remove = QueuedEpisode.where(user: current_user, episode_id: episode_ids_to_dequeue)
    queued_episodes_to_remove.delete_all

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js { render 'tv_shows/update_search_results' }
    end
  end

  def mass_mark_viewed
    tmdb_id = mass_mark_viewed_params[1]
    puts tmdb_id
    season, episode = mass_mark_viewed_params[0][:season], mass_mark_viewed_params[0][:episode]
    current_season = season.to_i.abs
    last_episode = episode.to_i.abs

    episodes = TvShow.find_by(tmdb_id: tmdb_id).episodes.all

    episodes.each do |e|
      if e.season < current_season
        watched = QueuedEpisode.find_by(user: current_user, episode: e)
        watched.viewed = true
        watched.save
      elsif e.season == current_season && e.episode_number <= last_episode
        watched = QueuedEpisode.find_by(user: current_user, episode: e)
        watched.viewed = true
        watched.save
      end
    end

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  private

  def search_for_show(query_string)
    potential_show_data = []
    response = open("https://api.themoviedb.org/3/search/tv?api_key=#{ENV['TMDB_API_KEY']}&language=en-US&query=#{URI.escape(query_string)}").read
    potential_shows = JSON.parse(response)

    potential_shows["results"].each do |r|
      potential_show_data << {tmdb_id: r["id"], poster_path: r["poster_path"], first_air_date: r["first_air_date"], title: r["name"]}
    end
    return potential_show_data
  end

  def search_query_params
    params.require(:search_query)
  end

  def add_or_remove_show_params
    params.permit(:first_air_date, :poster_path, :title, :tmdb_id)
  end

  def tv_show_params
    params.require(:tv_show).permit(:query_string)
  end

  def mass_mark_viewed_params
    params.require([:show, :tmdb_id])
  end

end
