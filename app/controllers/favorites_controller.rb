class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.includes(anime: :ratings).order(created_at: :desc)
    @total = @favorites.size

    anime_ids = @favorites.filter_map(&:anime_id)

    @fav_by_genre = @favorites.group_by { |f| f.anime&.genre }
                              .transform_values(&:count)
                              .compact

    @top_genre = @fav_by_genre.max_by { |_, v| v }&.first

    @my_ratings_map = anime_ids.any? ?
      current_user.ratings.where(anime_id: anime_ids).index_by(&:anime_id) : {}

    @avg_fav_rating = anime_ids.any? ?
      Rating.where(anime_id: anime_ids).average(:score)&.to_f&.round(2) : nil

    @rated_count = @my_ratings_map.size

    @top_rated_fav = @favorites.max_by { |f| f.anime&.average_rating.to_f }

    @first_favorited_at = @favorites.last&.created_at
    @last_favorited_at  = @favorites.first&.created_at
  end
end
