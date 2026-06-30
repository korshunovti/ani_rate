class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  validates :score, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :anime_id }
end
