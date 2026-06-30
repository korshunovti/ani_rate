class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dish, null: false, foreign_key: true

      t.timestamps
    end

    add_index :favorites, [:user_id, :dish_id], unique: true
  end
end
