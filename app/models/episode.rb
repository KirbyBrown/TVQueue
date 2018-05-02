class Episode < ApplicationRecord
  belongs_to :tv_show
  has_many :queued_episodes, dependent: :destroy
  has_many :users, through: :queued_episodes
end
