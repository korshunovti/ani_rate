class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :anime
  validates :user_id, uniqueness: { scope: :anime_id }
end
