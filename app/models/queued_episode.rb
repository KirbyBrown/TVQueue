class QueuedEpisode < ApplicationRecord
  belongs_to :user
  belongs_to :episode

  scope :for_tv_show, ->(tv_show) { joins(:episodes).merge(Episode.where(tv_show: tv_show)) }

  validates :episode, uniqueness: { scope: :user }
end
