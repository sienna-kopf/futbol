require './test/test_helper'
require './lib/season_statistics'
require './lib/game_collection'
require './lib/game'
require './lib/team_collection'
require './lib/team'
require './lib/game_team_collection'
require './lib/game_team'
require './lib/season_statistics'

class SeasonStatisticsTest < Minitest::Test
  def setup ## instantiate using the from_csv
    @game_path = './data/fixtures/game_fixture.csv'
    # @game_path = './data/games.csv'
    @team_path = './data/fixtures/team_fixture.csv'
    # @team_path = './data/teams.csv'
    @game_teams_path = './data/fixtures/game_teams_fixture.csv'
    # @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @season_statistics = SeasonStatistics.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of SeasonStatistics, @season_statistics
  end

  def test_it_has_attributes
    assert_equal './data/fixtures/game_fixture.csv', @season_statistics.games
    assert_equal './data/fixtures/team_fixture.csv', @season_statistics.teams
    assert_equal './data/fixtures/game_teams_fixture.csv', @season_statistics.game_teams
  end

  def test_it_can_have_game_collection
    assert_instance_of GameCollection, @season_statistics.game_collection
  end

  def test_it_can_have_team_collection
    assert_instance_of TeamCollection, @season_statistics.team_collection
  end

  def test_it_can_have_game_team_collection
    assert_instance_of GameTeamCollection, @season_statistics.game_team_collection
  end

  def test_it_can_select_games_based_on_season
    assert_equal 3, @season_statistics.games_by_season("20162017").count
    assert_equal 4, @season_statistics.games_by_season("20122013").count
    assert_equal 6, @season_statistics.games_by_season("20132014").count
    assert_equal Array, @season_statistics.games_by_season("20162017").class
    assert_equal Game, @season_statistics.games_by_season("20162017").first.class
  end

  def test_it_can_group_season_games_by_team_id
    assert_equal 3, @season_statistics.season_games_grouped_by_team_id("20162017").count
    assert_equal 6, @season_statistics.season_games_grouped_by_team_id("20132014").count
    assert_equal Game, @season_statistics.season_games_grouped_by_team_id("20122013").values[0][0].class
    assert_equal "2016030235", @season_statistics.season_games_grouped_by_team_id("20162017").keys[0]
  end

  def test_it_can_select_game_teams_by_season
    assert_equal 2, @season_statistics.game_teams_by_season("20162017").count
    assert_equal 6, @season_statistics.game_teams_by_season("20132014").count
    assert_equal GameTeam, @season_statistics.game_teams_by_season("20162017")[0].class
  end

  def test_it_can_determine_the_winningest_coach
    skip
    expected1 = ["Darryl Sutter", "Ralph Krueger"]
    assert_includes expected1, @season_statistics.winningest_coach("20122013")
    expected2 = ["Ken Hitchcock", "Alain Vigneault"]
    assert_includes expected2, @season_statistics.winningest_coach("20142015")
    assert_equal "Mike Yeo", @season_statistics.winningest_coach("20162017")
  end

  def test_ot_can_group_game_teams_by_head_coach
    expected_coaches = ["Ken Hitchcock", "Darryl Sutter", "Ralph Krueger", "Mike Yeo"]
    assert_equal expected_coaches, @season_statistics.group_season_game_teams_by_coach("20122013").keys
    assert_equal GameTeam, @season_statistics.group_season_game_teams_by_coach("20122013").values[0][0].class
    assert_equal "Ken Hitchcock", @season_statistics.group_season_game_teams_by_coach("20122013").values[0][0].head_coach
  end

  def test_it_can_filter_game_teams_by_coach_to_just_be_wins
    assert_equal [], @season_statistics.filter_coaches_game_teams_for_season_to_wins("20122013")["Ken Hitchcock"]
    assert_equal "WIN", @season_statistics.filter_coaches_game_teams_for_season_to_wins("20122013")["Darryl Sutter"][0].result
  end

  def test_count_season_wins_grouped_by_coach
    assert_equal 1, @season_statistics.count_season_wins_grouped_by_coach("20122013")["Ralph Krueger"]
    assert_equal 0, @season_statistics.count_season_wins_grouped_by_coach("20122013")["Mike Yeo"]
  end

  def test_it_can_determine_the_coach_with_the_most_wins
    assert_equal "Mike Yeo", @season_statistics.determine_coach_with_most_wins("20132014")
    expected = ["Darryl Sutter", "Ralph Krueger"]
    assert_includes expected, @season_statistics.determine_coach_with_most_wins("20122013")
  end

  def test_it_can_determine_the_worst_coach
    expected = ["Patrick Roy", "Bruce Boudreau", "Ken Hitchcock"]
    assert_includes expected, @season_statistics.worst_coach("20122013")
    assert_equal "Mike Yeo", @season_statistics.worst_coach("20142015")
    assert_equal "Peter Laviolette", @season_statistics.worst_coach("20162017")
  end

  # def test_it_can_count_up_goals_for_teams_over_a_season
  #   skip
  #   assert_equal 4, @season_statistics.total_season_goals_grouped_by_team("20122013")["22"]
  #   assert_equal ["19", "26", "22", "30"], @season_statistics.total_season_goals_grouped_by_team("20122013").keys
  #   assert_equal [0,1,4,1], @season_statistics.total_season_goals_grouped_by_team("20122013").values
  # end
  #
  # def test_it_can_count_up_shots_for_teams_over_a_season
  #   skip
  #   assert_equal 9, @season_statistics.total_season_shots_grouped_by_team("20122013")["30"]
  #   assert_equal ["19", "26", "22", "30"], @season_statistics.total_season_shots_grouped_by_team("20122013").keys
  #   assert_equal [7,5,4,9], @season_statistics.total_season_shots_grouped_by_team("20122013").values
  # end
  #
  # def test_it_can_get_the_ratio_of_shots_to_goals_for_the_season
  #   skip
  #   assert_equal 0.2, @season_statistics.season_ratio_goals_to_shots_grouped_by_team("20122013")["26"]
  #   assert_equal 1.0, @season_statistics.season_ratio_goals_to_shots_grouped_by_team("20122013")["22"]
  #   assert_equal ["19", "26", "22", "30"], @season_statistics.season_ratio_goals_to_shots_grouped_by_team("20122013").keys
  # end

  def test_it_can_determine_the_most_accurate_team
    assert_equal "Washington Spirit FC", @season_statistics.most_accurate_team("20122013")
    assert_equal "Houston Dynamo", @season_statistics.most_accurate_team("20142015")
  end

  def test_it_can_determine_the_least_accurate_team
    assert_equal "Philadelphia Union", @season_statistics.least_accurate_team("20122013")
    assert_equal "Orlando City SC", @season_statistics.least_accurate_team("20142015")
    assert_equal "Minnesota United FC", @season_statistics.least_accurate_team("20162017")
  end

  def test_it_can_return_team_name_based_off_of_team_id
    assert_equal "Philadelphia Union", @season_statistics.team_name_based_off_of_team_id("19")
    assert_nil nil, @season_statistics.team_name_based_off_of_team_id("5")
  end

  def test_it_can_count_up_tackles_for_a_team_for_the_season
    assert_equal 53, @season_statistics.total_season_tackles_grouped_by_team("20122013")["26"]
    assert_equal ["19", "26", "22", "30"], @season_statistics.total_season_tackles_grouped_by_team("20122013").keys
    assert_equal [39, 53, 15, 25], @season_statistics.total_season_tackles_grouped_by_team("20122013").values
  end

  def test_it_can_determine_the_team_with_the_most_tackles
    assert_equal "FC Cincinnati", @season_statistics.most_tackles("20122013")
    assert_equal "Orlando City SC", @season_statistics.most_tackles("20142015")
    assert_equal "Philadelphia Union", @season_statistics.most_tackles("20162017")
  end

  def test_it_can_determine_the_team_with_the_fewest_tackles
    assert_equal "Washington Spirit FC", @season_statistics.fewest_tackles("20122013")
    assert_equal "DC United", @season_statistics.fewest_tackles("20142015")
    assert_equal "Minnesota United FC", @season_statistics.fewest_tackles("20162017")
  end

  def test_creates_collections_once
    collection1 = @season_statistics.game_team_collection_to_use
    collection2 = @season_statistics.game_team_collection_to_use
    assert_equal true, collection1 == collection2
    assert_equal Array, @season_statistics.game_collection_to_use.class
    assert_equal Array, @season_statistics.team_collection_to_use.class
    assert_equal Array, @season_statistics.game_team_collection_to_use.class
  end
end
