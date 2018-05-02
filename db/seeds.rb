# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

tester_zero = User.create(email: "tester_zero@example.com", password: "t0pass")
tester_zero_shows_array = [60573, 71737, 16420]
tester_zero_shows_array.each do |e|
  show = TvShow.find_or_create_by(tmdb_id: e)

  response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
  tmdb_data = JSON.parse(response)
  number_of_seasons = tmdb_data["number_of_seasons"]

  number_of_seasons.times do |season|
    response = open("https://api.themoviedb.org/3/tv/#{show.tmdb_id}/season/#{season + 1}?api_key=#{ENV['TMDB_API_KEY']}&language=en-US").read
    episodes = JSON.parse(response)
    number_of_episodes = episodes["episodes"].count
    puts number_of_episodes
    number_of_episodes.times do |episode|
      puts "season, episode: #{season}, #{episode}"
      puts episode.class
      new_episode = Episode.create(tv_show: show, season: season, airdate: episodes["episodes"][episode]["air_date"].to_date)
      new_episode.save
      queued_episode = QueuedEpisode.create(episode: new_episode, user: tester_zero)
    end
  end
end
