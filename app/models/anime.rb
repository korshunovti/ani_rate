class Anime < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  validates :title, presence: true
  validates :genre, presence: true
  validates :image_url, presence: true
  # Средняя экспертная оценка
  def average_rating
    ratings.average(:score)&.round(2)
  end
end







 

