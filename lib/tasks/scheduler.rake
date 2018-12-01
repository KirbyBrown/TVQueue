desc "This task is called by the Heroku scheduler add-on"
task :update_recently_used_data => :environment do
  recent_users = User.where("last_seen_at < ?", (Time.now - 24.hours))
  recent_shows = TvShow.for_user(recent_users)
  recent_shows.each do |show|
    show.add_or_update
    show.add_or_update_episodes
    show.add_or_update_network
  end
end
