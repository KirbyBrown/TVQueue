require 'open-uri'
class TvShowsController < ApplicationController
  before_action :authenticate_user!

  def search

  end

  def search_results
    @search_string = search_query_params
    @potential_show_data = search_for_show(@search_string)
    @tv_show = TvShow.new
  end

  def add
    show_to_add = add_show_params
    @tv_show = TvShow.find_or_initialize_by(tmdb_id: show_to_add[:tmdb_id])
    add_or_update_show(@tv_show)
    @tv_show = TvShow.find_by(tmdb_id: show_to_add[:tmdb_id])
    add_episodes(@tv_show)
    queue_episodes(@tv_show)

    respond_to do |format|
      format.html { redirect_to root_url, notice: "#{@tv_show.title} successfully added to queue." }
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

  def retrieve_show()

  end

  def search_query_params
    params.require(:search_query)
  end

  def add_show_params
    params.permit(:first_air_date, :poster_path, :title, :tmdb_id)
  end

  def tv_show_params
    params.require(:tv_show).permit(:query_string)
  end

end
