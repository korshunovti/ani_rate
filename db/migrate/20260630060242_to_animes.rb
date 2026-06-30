class ToAnimes < ActiveRecord::Migration[7.2]
  def change
    rename_table :dishes, :animes
    rename_column :animes, :theme, :genre
    rename_column :ratings, :dish_id, :anime_id
    rename_column :favorites, :dish_id, :anime_id
  end
end
