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

  def tv_show_params
    params.require(:tv_show).permit(:query_string)
  end

end
