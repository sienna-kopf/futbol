require './test/test_helper'
require './lib/team_statistics'
require './lib/game_collection'
require './lib/game'
require './lib/team_collection'
require './lib/team'
require './lib/game_team_collection'
require './lib/game_team'
require './lib/team_statistics'

class TeamStatisticsTest < Minitest::Test
  def setup ## instantiate using the from_csv
    @game_path = './data/fixtures/game_fixture.csv'
#     @game_path = './data/games.csv'
    @team_path = './data/fixtures/team_fixture.csv'
#     @team_path = './data/teams.csv'
    @game_teams_path = './data/fixtures/game_teams_fixture.csv'
#     @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @team_statistics = TeamStatistics.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of TeamStatistics, @team_statistics
  end

  def test_it_has_attributes
    assert_equal './data/fixtures/game_fixture.csv', @team_statistics.games
    assert_equal './data/fixtures/team_fixture.csv', @team_statistics.teams
    assert_equal './data/fixtures/game_teams_fixture.csv', @team_statistics.game_teams
  end

  def test_it_can_have_game_collection
    assert_instance_of GameCollection, @team_statistics.game_collection
  end

  def test_it_can_have_team_collection
    assert_instance_of TeamCollection, @team_statistics.team_collection
  end

  def test_it_can_have_game_team_collection
    assert_instance_of GameTeamCollection, @team_statistics.game_team_collection
  end

  def test_it_can_get_team_info
    expected = {
                "team_id" => "30",
                "franchise_id" => "37",
                "team_name" => "Orlando City SC",
                "abbreviation" => "ORL",
                "link" => "/api/v1/teams/30"
                }
    assert_equal expected, @team_statistics.team_info("30")
  end

  def test_it_can_filter_home_games_by_team
    assert_equal 5, @team_statistics.home_games_filtered_by_team("19").count
  end

  def test_it_can_filter_away_games_by_team
    assert_equal 7, @team_statistics.away_games_filtered_by_team("19").count
  end

  def test_it_can_group_home_games_by_season
    assert_equal true, @team_statistics.home_games_grouped_by_season("19").keys.include?("20142015")
    assert_equal true,
    @team_statistics.home_games_grouped_by_season("19").keys.include?("20162017")
    assert_equal false, @team_statistics.home_games_grouped_by_season("19").keys.include?(:tie)
  end

  def test_it_can_group_away_games_by_season
    assert_equal true, @team_statistics.away_games_grouped_by_season("19").keys.include?("20142015")
    assert_equal true,
    @team_statistics.away_games_grouped_by_season("19").keys.include?("20122013")
    assert_equal false, @team_statistics.away_games_grouped_by_season("19").keys.include?(:home_win)
  end

  def test_it_can_get_number_of_home_wins_in_season
    assert_equal true, @team_statistics.season_home_wins("19").values.include?(2.0)
  end

  def test_it_can_get_number_of_away_wins_in_season
    assert_equal true, @team_statistics.season_away_wins("19").values.include?(1.0)
  end

  def test_it_can_get_total_wins_in_a_season
    assert_equal true, @team_statistics.win_count_by_season("19").values.include?(-1.0)
  end

  def test_it_can_get_best_season
    assert_equal "20162017", @team_statistics.best_season("19")
  end

  def test_it_can_get_number_of_home_losses_in_season
    assert_equal true, @team_statistics.season_home_losses("19").values.include?(-1.0)
  end

  def test_it_can_get_number_of_away_losses_in_season
    assert_equal true, @team_statistics.season_away_losses("19").values.include?(-1.0)
  end

  def test_it_can_get_total_losses_in_a_season
    assert_equal true, @team_statistics.loss_count_by_season("19").values.include?(1.0)
  end

  def test_it_can_get_worst_season
    assert_equal "20122013", @team_statistics.worst_season("19")
  end

  def test_it_can_get_all_games_played_by_a_team
    assert_equal 12, @team_statistics.combine_all_games_played("19").count
  end

  def test_it_can_total_wins_or_ties_for_a_team
    assert_equal 0.5, @team_statistics.find_total_wins_or_ties("19")
  end

  def test_it_can_get_average_win_percentage
    assert_equal Float, @team_statistics.average_win_percentage("19").class
  end

  def test_it_can_get_most_home_goals_scored
    assert_equal 3, @team_statistics.most_home_goals_scored("19")
  end

  def test_it_can_get_most_away_goals_scored
    assert_equal 4, @team_statistics.most_away_goals_scored("19")
  end

  def test_it_can_get_most_goals_scored
    assert_equal 4, @team_statistics.most_goals_scored("19")
    assert_equal 3, @team_statistics.most_goals_scored("30")
    assert_equal 4, @team_statistics.most_goals_scored("26")
  end

  def test_it_can_get_fewest_home_goals_scored
    assert_equal 3, @team_statistics.most_home_goals_scored("19")
  end

  def test_it_can_get_fewest_away_goals_scored
    assert_equal 4, @team_statistics.most_away_goals_scored("19")
  end

  def test_it_can_get_fewest_goals_scored
    assert_equal 0, @team_statistics.fewest_goals_scored("19")
    assert_equal 0, @team_statistics.fewest_goals_scored("30")
  end

  def test_it_can_get_all_games_played_by_team
    assert_equal Array, @team_statistics.all_games_played_by_team("19").class
  end

  def test_it_can_get_team_opponents
    assert_equal Hash, @team_statistics.opponents("19").class
  end

  def test_it_can_get_opponent_win_percentages
    assert_equal Hash, @team_statistics.opponent_win_percentages("19").class
  end

  def test_it_can_get_most_won_against_opponent
    assert_equal "30", @team_statistics.most_won_against_opponent("19")
  end

  def test_it_can_get_favorite_opponent
    assert_equal "Orlando City SC", @team_statistics.favorite_opponent("19")
  end

  def test_it_can_get_most_lost_against_opponent
    assert_equal "23", @team_statistics.most_lost_against_opponent("19")
  end

  def test_it_can_get_rival
    assert_equal "Montreal Impact", @team_statistics.rival("19")
  end

end
