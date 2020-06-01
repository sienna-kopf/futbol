require './test/test_helper'
require './lib/stat_tracker'
require './lib/league'

class LeagueTest < Minitest::Test
  def setup
    @league = League.new



end

  def test_it_exists
    skip
    assert_instance_of League, @league
  end

  def test_it_has_count_of_teams
    skip
    assert_equal 10, @teams.count 
  end

  def test_it_has_best_offense
    skip

  end

  def test_it_has_worst_offense
    skip

  end

  def test_it_has_highest_scoring_visitor
    skip

  end

  def test_it_has_highest_scoring_home_team
    skip

  end

  def test_it_has_lowest_scoring_visitor
    skip

  end

  def test_it_has_lowest_scoring_home_team
    skip

  end



end
