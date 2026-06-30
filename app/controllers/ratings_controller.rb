class RatingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ratings = current_user.ratings.includes(:anime).order(created_at: :desc)

    @total = @ratings.size
    @your_avg = current_user.ratings.average(:score)&.to_f

    @avg_by_genre = Anime.joins(:ratings)
                        .where(ratings: { user_id: current_user.id })
                        .group(:genre)
                        .average("ratings.score")
                        .transform_values { |v| v&.to_f }

    @count_by_genre = Anime.joins(:ratings)
                          .where(ratings: { user_id: current_user.id })
                          .group(:genre)
                          .count("ratings.id")

    @global_by_genre = Anime.joins(:ratings)
                           .group(:genre)
                           .average("ratings.score")
                           .transform_values { |v| v&.to_f }

    @latest = @ratings.limit(12)
  end
end
