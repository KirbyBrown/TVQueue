# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

# Create users
puts "Creating users..."
test_user_names = ["tester_zero", "tester_one", "tester_two", "tester_three"]
test_users = []
test_user_names.each_with_index do |user, index|
  user = User.create(email: "#{user}@example.com", password: "t#{index}pass", confirmed: true, confirmed_at: Time.zone.now)
  test_users << user
end

# Create shows
puts "Creating shows..."
shows_array = [71737, 60573, 16420, 61692, 66551]

shows_array.each do |e|
  show = TvShow.find_or_initialize_by(tmdb_id: e)

  response = open("https://api.themoviedb.org/3/tv/#{e}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
  tmdb_data = JSON.parse(response)

  show.title = tmdb_data["name"]
  show.number_of_seasons = tmdb_data["number_of_seasons"]
  show.poster_path = tmdb_data["poster_path"]
  show.save

  number_of_seasons = show.number_of_seasons

# Create episodes
  number_of_seasons.times do |season|
    season_number = season + 1
    puts "Creating episodes for #{show.title} season #{season_number}..."
    response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}/season/#{season_number}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
    episodes = JSON.parse(response)
    number_of_episodes = episodes["episodes"].count
    number_of_episodes.times do |episode|
      new_episode = Episode.create(tv_show: show, season: season_number, episode_number: episodes["episodes"][episode]["episode_number"], airdate: episodes["episodes"][episode]["air_date"].to_date, title: episodes["episodes"][episode]["name"], still_path: episodes["episodes"][episode]["still_path"])
      new_episode.save
    end
  end
end

# Queue episodes
puts "Populating user's queues..."
TvShow.all.each_with_index do |show, i|
  User.all.each_with_index do |user, j|
    if (j + 1) % (i + 1) == 0
      show.episodes.each do |episode_to_queue|
        queued_episode = QueuedEpisode.create(episode: episode_to_queue, user: user)
      end
    end
  end
end
