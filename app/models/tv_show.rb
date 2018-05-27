class TvShow < ApplicationRecord
  has_many :episodes, dependent: :destroy
  belongs_to :network, { optional: true }

  scope :for_user, ->(user) { joins(:episodes).merge(Episode.for_user(user)).distinct }

  validates :tmdb_id, presence: true, uniqueness: true
end
