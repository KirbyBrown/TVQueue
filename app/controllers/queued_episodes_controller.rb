require 'open-uri'
class QueuedEpisodesController < ApplicationController
  before_action :authenticate_user!

  def toggle_viewed_status
     queued_episode = current_user.queued_episodes.find_by(id: toggle_viewed_status_params["queued_episode_id"])
     queued_episode.viewed = !queued_episode.viewed
     queued_episode.save

     respond_to do |format|
       format.html { redirect_to root_url, notice: " " }
     end


  end

  def index
    @user = current_user
    @complete_queue = @user.queued_episodes.joins(:episode).order('episodes.airdate desc')
    @unwatched_queue = @user.queued_episodes.where(viewed: false)
  end

  private

  def toggle_viewed_status_params
    params.permit(:queued_episode_id)
  end

end
