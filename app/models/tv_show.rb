class TvShow < ApplicationRecord
  has_many :episodes
  belongs_to :network
end
