# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
game_data = YAML.load_file('config/game.yml')

i = 0
while i < game_data["num_planets"]
    size = rand(game_data["min_planet_size"]..game_data["max_planet_size"])
    population = size * game_data["population_per_planet_size"]
    
    begin
        Planet.create!(
            x: rand(1..game_data["map_width"]),
            y: rand(1..game_data["map_height"]),
            size: size,
            population: population
        )
        i += 1
    rescue => ex
    end
end