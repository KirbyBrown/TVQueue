require 'open-uri'

class EpisodesController < ApplicationController

  def index

  end

  def show

    response = open("https://api.themoviedb.org/3/tv/#{params[:id]}/season/1?api_key=#{ENV['TMDB_API_KEY']}&languate=en-US").read

    @season = JSON.parse(response)

  end

end
