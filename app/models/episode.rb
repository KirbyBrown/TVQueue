class Episode < ApplicationRecord
  belongs_to :tv_show
  has_many :queued_episodes, dependent: :destroy
  scope :for_user, ->(user) { joins(:queued_episodes).merge(QueuedEpisode.where(user: user)) }
end
