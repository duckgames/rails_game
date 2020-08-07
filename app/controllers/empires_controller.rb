class EmpiresController < ApplicationController
  def new
      @empire = Empire.new
  end

  def create
      game_data = YAML.load_file('config/game.yml')

      planet = Planet.where("empire_id IS NULL").order(Arel.sql('RANDOM()')).first

      if planet != nil
          @empire = Empire.create(
              name: params[:empire][:name],
              user: current_user,
              cash: game_data["starting_cash"],
              energy: game_data["starting_energy"],
              metals: game_data["starting_metal"],
              ground_units: game_data["starting_ground_units"],
              air_units: game_data["starting_air_units"]
          )
          if @empire
              planet.size = game_data["starting_planet_size"]
              planet.population = planet.size * game_data["population_per_planet_size"]
              planet.empire = @empire
              planet.save
              redirect_to root_url
          else
              redirect_to static_pages_failure_url
          end
      else
          redirect_to static_pages_failure_url
      end
  end
end