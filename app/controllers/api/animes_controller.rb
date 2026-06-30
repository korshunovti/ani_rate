module Api
  class AnimesController < ApplicationController
    before_action :authenticate_user!

    def next
      genre = params[:genre].to_s
      genre = "" if genre == "random"
      scope = genre.present? ? Anime.where(genre: genre) : Anime.all

      anime = scope.order(Arel.sql("RANDOM()")).first
      return render json: { anime: nil, message: "No anime for this genre" } if anime.nil?

      my_rating = Rating.find_by(user: current_user, anime: anime)&.score
      is_favorite = Favorite.exists?(user: current_user, anime: anime)

      render json: {
        anime: {
          id: anime.id,
          title: anime.title,
          genre: anime.genre,
          image_url: anime.image_url,
          average_rating: anime.average_rating,
          is_favorite: is_favorite
        },
        my_rating: my_rating
      }
    end
  end
end


