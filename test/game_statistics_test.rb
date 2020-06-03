require './test/test_helper'
require './lib/game_collection'
require './lib/game'
require './lib/game_team_collection'
require './lib/game_team'
require './lib/stat_tracker'
require './lib/game_statistics'

class GameStatisticsTest < Minitest::Test
  def setup
    @game_path = './data/fixtures/game_fixture.csv'
    #     @game_path = './data/games.csv'
    @game_teams_path = './data/fixtures/game_teams_fixture.csv'
    #     @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      game_teams: @game_teams_path
    }

    @game_statistics = GameStatistics.from_csv(@locations)
  end

  def test_it_has_attributes
    assert_equal './data/fixtures/game_fixture.csv', @game_statistics.games
    assert_equal './data/fixtures/game_teams_fixture.csv', @game_statistics.game_teams
  end

  def test_it_can_have_game_collection
    assert_instance_of GameCollection, @game_statistics.game_collection
  end

  def test_it_can_have_game_team_collection
    assert_instance_of GameTeamCollection, @game_statistics.game_team_collection
  end

  # JUDITH START HERE
  def test_it_can_get_highest_total_score
    assert_equal 8, @game_statistics.highest_total_score
  end

  def test_it_can_get_lowest_total_score
    assert_equal 1, @game_statistics.lowest_total_score
  end

  def test_it_can_get_percentage_of_home_wins
    assert_equal 0.44, @game_statistics.percentage_home_wins
  end

  def test_it_can_get_percentage_of_visitor_wins
    assert_equal 0.44, @game_statistics.percentage_visitor_wins
  end

  def test_it_can_get_percentage_of_ties
    assert_equal 0.11, @game_statistics.percentage_ties
  end

  def test_count_of_games_by_season
    expected = {
      "20132014"=>6,
      "20142015"=>4,
      "20162017"=>3,
      "20122013"=>4
    }
    assert_equal expected, @game_statistics.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 7.33, @game_statistics.average_goals_per_game
  end

  def test_sum_of_goals_per_season
    assert_equal 12, @game_statistics.sum_of_goals_per_season("20122013")
  end

  def test_average_goals_per_season
    assert_equal 3.0, @game_statistics.average_goals_per_season("20122013")
  end

  def test_average_goals_by_season
    expected = {
              "20132014"=>4.0,
              "20142015"=>4.75,
              "20162017"=>3.67,
              "20122013"=>3.0
                }
    assert_equal expected, @game_statistics.average_goals_by_season
  end
  # JUDITH END HERE

end
