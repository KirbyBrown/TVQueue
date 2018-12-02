desc "This task is called by the Heroku scheduler add-on"
require 'open-uri'

task :update_recently_used_data => :environment do
  recent_users = User.where("last_seen_at > ?", (Time.now - 3.months))
  recent_shows = TvShow.for_user(recent_users)
  recent_shows.each do |show|
    show.add_or_update
    show.add_or_update_episodes
    show.add_or_update_network
    sleep(0.25)
  end
end
