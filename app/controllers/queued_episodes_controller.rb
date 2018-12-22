require 'open-uri'
class QueuedEpisodesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_last_seen_at, if: proc { current_user && (current_user.last_seen_at.nil? || current_user.last_seen_at < 15.minutes.ago) }

  def toggle_viewed_status
     queued_episode = current_user.queued_episodes.find_by(id: toggle_viewed_status_params["queued_episode_id"])
     queued_episode.viewed = !queued_episode.viewed
     queued_episode.save

     respond_to do |format|
       format.html { redirect_to root_url, turbolinks: false }
     end
  end

  def index
    @user = current_user
    filter = params[:filter] ? params[:filter] : nil
    sort = params[:sort] ? params[:sort] : nil

    @complete_queue = (filter == 'new') ? @user.queued_episodes.joins(:episode).where("queued_episodes.viewed = ?", episode_filter(filter)).order(episode_sort(sort)) : @user.queued_episodes.joins(:episode).order(episode_sort(sort))
    @next_episode = @complete_queue.where(viewed: false).last || @complete_queue.first
    @full_show_list = TvShow.for_user(@user)


    cqe = Episode.where(id: @complete_queue.map(&:episode_id))
    cqt = TvShow.where(id: cqe.map(&:tv_show_id).uniq)

#    cqt.each do |show|
#      show.add_or_update
#      show.add_or_update_episodes
#      show.add_or_update_network
#    end
  end

  private

  def episode_filter(method)
    case method
    when 'new' then
      return 'false'
    end
  end

  def episode_sort(method)
    case method
    when 'showa' then
      return 'episodes.title asc'
    when 'showd' then
      return 'episodes.title desc'
    when 'datea' then
      return 'episodes.airdate asc'
    when 'dated' then
      return 'episodes.airdate desc'
    else
      return 'episodes.airdate desc, episodes.season desc, episodes.episode_number desc'
    end
  end

  def toggle_viewed_status_params
    params.permit(:queued_episode_id)
  end

  def queue_params
    params.permit(:filter, :sort)
  end
end
