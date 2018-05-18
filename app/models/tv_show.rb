class TvShow < ApplicationRecord
  has_many :episodes
  belongs_to :network
  scope :for_user, ->(user) { joins(:episodes).merge(Episode.for_user(user)).distinct }
end
