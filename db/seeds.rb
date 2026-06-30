Anime.destroy_all

# Shonen
Anime.create!(title: "Attack on Titan", genre: "shonen", image_url: "/assets/attack.jpg")
Anime.create!(title: "Naruto", genre: "shonen", image_url: "/assets/Naruto.jpg")
Anime.create!(title: "Demon Slayer", genre: "shonen", image_url: "/assets/Demon.jpg")

# Shoujo
Anime.create!(title: "Sailor Moon", genre: "shoujo", image_url: "/assets/Sailor.jpg")
Anime.create!(title: "Fruits Basket", genre: "shoujo", image_url: "/assets/Fruits.jpg")
Anime.create!(title: "Ouran High School Host Club", genre: "shoujo", image_url: "/assets/Ouran.jpg")

# Mecha
Anime.create!(title: "Code Geass", genre: "mecha", image_url: "/assets/Code.jpg")
Anime.create!(title: "Neon Genesis Evangelion", genre: "mecha", image_url: "/assets/Evangelion.jpg")
Anime.create!(title: "Gundam", genre: "mecha", image_url: "/assets/Gundam.jpg")

# Fantasy
Anime.create!(title: "Spirited Away", genre: "fantasy", image_url: "/assets/Spirited.jpg")
Anime.create!(title: "Made in Abyss", genre: "fantasy", image_url: "/assets/Abyss.jpg")
Anime.create!(title: "Mushishi", genre: "fantasy", image_url: "/assets/Mushishi.jpg")

# Romance
Anime.create!(title: "Your Lie in April", genre: "romance", image_url: "/assets/April.jpg")
Anime.create!(title: "Toradora!", genre: "romance", image_url: "/assets/Toradora!.jpg")
Anime.create!(title: "Clannad", genre: "romance", image_url: "/assets/Clannad.jpg")

puts "Создано #{Anime.count} аниме"
