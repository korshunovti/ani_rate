module Api
  class FavoritesController < ApplicationController
    before_action :authenticate_user!

    def toggle
      anime_id = params[:anime_id]
      fav = Favorite.find_by(user: current_user, anime_id: anime_id)

      if fav
        fav.destroy!
        render json: { ok: true, favorited: false }
      else
        Favorite.create!(user: current_user, anime_id: anime_id)
        render json: { ok: true, favorited: true }
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { ok: false, error: e.message }, status: :unprocessable_entity
    end
  end
end

