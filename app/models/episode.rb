class Episode < ApplicationRecord
  belongs_to :tv_show
  has_and_belongs_to_many :lists
end
