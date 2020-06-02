require './test/test_helper'
require './lib/stat_tracker'
require './lib/team'
require './lib/game'
require './lib/game_team'
require './lib/season'

class SeasonTest < Minitest::Test
  def setup
    @season = Season.new
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

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_can_determine_the_most_accurate_team
    assert_equal "Washington Spirit FC", @season.most_accurate_team("20122013")
    assert_equal "Houston Dynamo", @season.most_accurate_team("20142015")
  end

  def test_it_can_determine_the_least_accurate_team
    assert_equal "Philadelphia Union", @season.least_accurate_team("20122013")
    assert_equal "Orlando City SC", @season.least_accurate_team("20142015")
    assert_equal "Minnesota United FC", @season.least_accurate_team("20162017")
  end

  def test_it_can_return_team_name_based_off_of_team_id
    assert_equal "Philadelphia Union", @season.team_name_based_off_of_team_id("19")
    assert_nil nil, @season.team_name_based_off_of_team_id("5")
  end

  def test_it_can_count_up_tackles_for_a_team_for_the_season
    assert_equal 53, @season.total_season_tackles_grouped_by_team("20122013")["26"]
    assert_equal ["19", "26", "22", "30"], @season.total_season_tackles_grouped_by_team("20122013").keys
    assert_equal [39, 53, 15, 25], @season.total_season_tackles_grouped_by_team("20122013").values
  end

  def test_it_can_determine_the_team_with_the_most_tackles
    assert_equal "FC Cincinnati", @season.most_tackles("20122013")
    assert_equal "Orlando City SC", @season.most_tackles("20142015")
    assert_equal "Philadelphia Union", @season.most_tackles("20162017")
  end

  def test_it_can_determine_the_team_with_the_fewest_tackles
    assert_equal "Washington Spirit FC", @season.fewest_tackles("20122013")
    assert_equal "DC United", @season.fewest_tackles("20142015")
    assert_equal "Minnesota United FC", @season.fewest_tackles("20162017")
  end

  def test_creates_collections_once
    collection1 = @season.game_team_collection_to_use
    collection2 = @season.game_team_collection_to_use
    assert_equal true, collection1 == collection2
    assert_equal Array, @season.game_collection_to_use.class
    assert_equal Array, @season.team_collection_to_use.class
    assert_equal Array, @season.game_team_collection_to_use.class
  end

  def test_it_can_select_games_based_on_season
    assert_equal 3, @season.games_by_season("20162017").count
    assert_equal 4, @season.games_by_season("20122013").count
    assert_equal 6, @season.games_by_season("20132014").count
    assert_equal Array, @season.games_by_season("20162017").class
    assert_equal Game, @season.games_by_season("20162017").first.class
  end

  def test_it_can_group_season_games_by_team_id
    assert_equal 3, @season.season_games_grouped_by_team_id("20162017").count
    assert_equal 6, @season.season_games_grouped_by_team_id("20132014").count
    assert_equal Game, @season.season_games_grouped_by_team_id("20122013").values[0][0].class
    assert_equal "2016030235", @season.season_games_grouped_by_team_id("20162017").keys[0]
  end

  def test_it_can_select_game_teams_by_season
    assert_equal 2, @season.game_teams_by_season("20162017").count
    assert_equal 6, @season.game_teams_by_season("20132014").count
    assert_equal GameTeam, @season.game_teams_by_season("20162017")[0].class
  end

  def test_it_can_determine_the_winningest_coach
    expected1 = ["Darryl Sutter", "Ralph Krueger"]
    assert_includes expected1, @season.winningest_coach("20122013")
    expected2 = ["Ken Hitchcock", "Alain Vigneault"]
    assert_includes expected2, @season.winningest_coach("20142015")
    assert_equal "Mike Yeo", @season.winningest_coach("20162017")
  end

  def test_it_can_determine_the_worst_coach
    expected = ["Patrick Roy", "Bruce Boudreau", "Ken Hitchcock"]
    assert_includes expected, @season.worst_coach("20122013")
    assert_equal "Mike Yeo", @season.worst_coach("20142015")
    assert_equal "Peter Laviolette", @season.worst_coach("20162017")
  end

end
