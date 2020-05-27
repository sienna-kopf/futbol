require './test/test_helper'
require './lib/stat_tracker'
require './lib/game'
require './lib/game_collection'

class GameCollectionTest < Minitest::Test

def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

end
