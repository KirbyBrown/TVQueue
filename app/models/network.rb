class Network < ApplicationRecord
  has_many :tv_shows

  validates :tmdb_id, presence: true
end
