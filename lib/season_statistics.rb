require_relative './game_collection'
require_relative './game'
require_relative './team_collection'
require_relative './team'
require_relative './game_team_collection'
require_relative './game_team'
require_relative '../modules/collectionable'
require_relative '../modules/memoizable'

class SeasonStatistics
  include Collectionable
  include Memoizable
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(data_files)
    @games = data_files[:games]
    @teams = data_files[:teams]
    @game_teams = data_files[:game_teams]
  end

  def self.from_csv(data_files)
    SeasonStatistics.new(data_files)
  end

  def games_by_season(season_id)
   game_collection_to_use.select do |game|
     season_id == game.season
   end
  end

  def season_games_grouped_by_team_id(season_id)
    collection = games_by_season(season_id).group_by do |game|
      game.game_id
    end
  end

  def game_teams_by_season(season_id)
    game_team_collection_to_use.select do |game_team|
      season_games_grouped_by_team_id(season_id).keys.include?(game_team.game_id)
    end
  end

  def team_name_based_off_of_team_id(team_id)
   team_collection_to_use.each do |team|
     return team.team_name if team_id == team.team_id
   end
  end

  def group_season_game_teams_by_coach(season_id)
    game_teams_by_season(season_id).group_by do |game_team|
      game_team.head_coach
    end
  end

  def filter_coaches_game_teams_for_season_to_wins(season_id)
    group_season_game_teams_by_coach(season_id).transform_values do |game_team_collection|
      game_team_collection.keep_if do |game_team|
        game_team.result == "WIN"
      end
    end
  end

  def count_season_wins_grouped_by_coach(season_id)
    filter_coaches_game_teams_for_season_to_wins(season_id).transform_values! do |game_team_collection|
      game_team_collection.count
    end
  end

  def determine_coach_with_most_wins(season_id)
    count_season_wins_grouped_by_coach(season_id).max_by do |coach, wins|
      wins
    end[0]
  end

  def winningest_coach(season_id)
    determine_coach_with_most_wins(season_id)
  end

   def worst_coach(season_id)
    coaches_hash = game_teams_by_season(season_id).group_by do |game_team|
      game_team.head_coach
    end
    coaches_hash.transform_values do |game_team_collection|
      game_team_collection.keep_if do |game_team|
        game_team.result == "WIN"
      end
    end
    coaches_hash.transform_values! do |game_team_collection|
      game_team_collection.count
    end
    worst_coach = coaches_hash.min_by do |coach, wins|
      wins
    end
    worst_coach[0]
  end

  def most_accurate_team(season_id)
    goals_for_season_by_team = Hash.new(0)
    game_teams_by_season(season_id).each do |game_team|
      goals_for_season_by_team[game_team.team_id] += game_team.goals.to_i
    end
    shots_for_season_by_team = Hash.new(0)
    game_teams_by_season(season_id).each do |game_team|
      shots_for_season_by_team[game_team.team_id] += game_team.shots.to_i
    end
    ratio_of_g_to_s_for_season_by_team = Hash.new(0)
      goals_for_season_by_team.each do |g_team_id, goals|
        shots_for_season_by_team.each do |s_team_id, shots|
          if s_team_id == g_team_id
            ratio_of_g_to_s_for_season_by_team[s_team_id] = goals.to_f / shots.to_f
          end
        end
      end

    best_team = ratio_of_g_to_s_for_season_by_team.max_by do |team_id, ratio|
      ratio
    end
    team_name_based_off_of_team_id(best_team[0])
  end

  def least_accurate_team(season_id)
    goals_for_season_by_team = Hash.new(0)
    game_teams_by_season(season_id).each do |game_team|
      goals_for_season_by_team[game_team.team_id] += game_team.goals.to_i
    end
    shots_for_season_by_team = Hash.new(0)
    game_teams_by_season(season_id).each do |game_team|
      shots_for_season_by_team[game_team.team_id] += game_team.shots.to_i
    end
    ratio_of_g_to_s_for_season_by_team = Hash.new(0)
      goals_for_season_by_team.each do |g_team_id, goals|
        shots_for_season_by_team.each do |s_team_id, shots|
          if s_team_id == g_team_id
            ratio_of_g_to_s_for_season_by_team[s_team_id] = goals.to_f / shots.to_f
          end
        end
      end
    worst_team = ratio_of_g_to_s_for_season_by_team.min_by do |team_id, ratio|
      ratio
    end
    team_name_based_off_of_team_id(worst_team[0])
  end

  def total_season_tackles_grouped_by_team(season_id)
    tackles_for_season_by_team = Hash.new(0)
    game_teams_by_season(season_id).each do |game_team|
      tackles_for_season_by_team[game_team.team_id] += game_team.tackles.to_i
    end
    tackles_for_season_by_team
  end

  def most_tackles(season_id)
    best_team = total_season_tackles_grouped_by_team(season_id).max_by do |team_id, tackles|
      tackles
    end
    team_name_based_off_of_team_id(best_team[0])
  end

  def fewest_tackles(season_id)
    worst_team = total_season_tackles_grouped_by_team(season_id).min_by do |team_id, tackles|
      tackles
    end
    team_name_based_off_of_team_id(worst_team[0])
  end

  ######################END of SEASON STATS####################
  # start of sienna's league stats
  def home_game_teams
    game_team_collection_to_use.find_all do |game_team|
      game_team.hoa == "home"
    end
  end

  def home_game_teams_by_team
    home_game_teams.group_by do |game_team|
      game_team.team_id
    end
  end

  def total_home_goals_grouped_by_team
    goals_by_team_id = Hash.new(0)
    home_game_teams_by_team.each do |team_id, game_team_coll|
      game_team_coll.each do |game_team|
        goals_by_team_id[team_id] += game_team.goals.to_i
      end
    end
    goals_by_team_id
  end

  def total_home_games_grouped_by_team
    games_by_team_id = Hash.new(0)
    home_game_teams_by_team.each do |team_id, game_team_coll|
      game_team_coll.each do |game_team|
        games_by_team_id[team_id] += 1
      end
    end
    games_by_team_id
  end

  def ratio_home_goals_to_games_grouped_by_team
    ratio_goals_to_games_by_team = Hash.new(0)
    total_home_games_grouped_by_team.each do |games_team_id, total_games|
      total_home_goals_grouped_by_team.each do |goals_team_id, total_goals|
        if games_team_id == goals_team_id
          ratio_goals_to_games_by_team[games_team_id] = (total_goals.to_f / total_games.to_f)
        end
      end
    end
    ratio_goals_to_games_by_team
  end

  def find_team_id_with_best_home_goals_to_games_ratio
    ratio_home_goals_to_games_grouped_by_team.max_by do |team_id, ratio_g_to_g|
      ratio_g_to_g
    end[0]
  end

  def find_team_id_with_worst_home_goals_to_games_ratio
    ratio_home_goals_to_games_grouped_by_team.min_by do |team_id, ratio_g_to_g|
      ratio_g_to_g
    end[0]
  end

  def highest_scoring_home_team
    team_name_based_off_of_team_id(find_team_id_with_best_home_goals_to_games_ratio)
  end

  def lowest_scoring_home_team
    team_name_based_off_of_team_id(find_team_id_with_worst_home_goals_to_games_ratio)
  end

  # end of sienna's league STATS

  #################START of SEASON STATS######################


  ## biggest slow down = iteration over same source of data
  ## Use memoization here as well here, Wont work super well if you have to send an arg to method
  ## how can you format this data so you dont need to reload it

  ## memoization = create an instance variable in a method set to something
  ## when called its calling that instance variable



## argument wont work, so memoization with only season will only return the first one
## think about a hash data type

##how many times are you iterating over the same data set and cut down significantly = less run time

# possible memo... not sure how to remove the argument
# def games_by_season_memo
#   @games_by_season_memo ||=  game_collection_to_use.select do |game|
#      season_id == game.season
#    end
# end
#
# def games_by_season(season_id)
#   games_by_season_memo[season_id]
# end
end
