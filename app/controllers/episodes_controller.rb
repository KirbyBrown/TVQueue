class EpisodesController < ApplicationController

  def index

  end

  def show
    @episodes = Tmdb::Tv::Season.detail(params[:id], 1)
  end

end
