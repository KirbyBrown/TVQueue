class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :queued_episodes, foreign_key: "user_id", dependent: :destroy
  has_many :episodes, through: :queued_episodes
  has_and_belongs_to_many :tv_shows
end
