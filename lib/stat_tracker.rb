require_relative './game_collection'
require_relative './game'
require_relative './team_collection'
require_relative './team'
require_relative './game_team_collection'
require_relative './game_team'

class StatTracker
  attr_reader :games,
              :teams,
              :game_teams

  def initialize(data_files)
    @games = data_files[:games]
    @teams = data_files[:teams]
    @game_teams = data_files[:game_teams]
  end

  def self.from_csv(data_files)
    StatTracker.new(data_files)
  end

  def game_collection
    GameCollection.new(@games)
  end

  def team_collection
    TeamCollection.new(@teams)
  end

  def game_team_collection
    GameTeamCollection.new(@game_teams)
  end

  def game_collection_to_use
    instantiate_game_collection
  end

  def instantiate_game_collection
    @instantiate_game_collection ||= game_collection.all
  end

  def game_team_collection_to_use
    instantiate_game_team_collection
  end

  def instantiate_game_team_collection
    @instantiate_game_team_collection ||= game_team_collection.all
  end

  def team_collection_to_use
    instantiate_team_collection
  end

  def instantiate_team_collection
    @instantiate_team_collection ||= team_collection.all
  end

# JUDITH START HERE
  def highest_total_score
    total = game_collection_to_use.max_by do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    total.away_goals.to_i + total.home_goals.to_i
  end

  def lowest_total_score
    total = game_collection_to_use.min_by do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    total.away_goals.to_i + total.home_goals.to_i
  end

  def home_games
    home_games = []
    game_team_collection.all.flat_map do |game_team|
      result = game_team.hoa == "home"
        home_games << result
      end
    home_games.count(true)
  end

  def percentage_home_wins
    home_wins = []
    game_team_collection.all.flat_map do |game_team|
      result = game_team.hoa == "home" && game_team.result == "WIN"
        home_wins << result
    end
    (home_wins.count(true) / home_games.to_f).round(2)
  end

  def visitor_games
    visitor_games = []
    game_team_collection.all.flat_map do |game_team|
      result = game_team.hoa == "away"
      visitor_games << result
    end
    visitor_games.count(true)
  end

  def percentage_visitor_wins
    visitor_wins = []
    game_team_collection.all.flat_map do |game_team|
      result = game_team.hoa == "away" && game_team.result == "WIN"
        visitor_wins << result
    end
    (visitor_wins.count(true) / visitor_games.to_f).round(2)
  end

  def all_games
    all_games = []
    game_team_collection.all.flat_map do |game_team|
      result = game_team.hoa
      all_games << result
    end
    all_games.count
  end

  def percentage_ties
    ties = []
    game_team_collection.all.flat_map do |game_team|
      result =  game_team.result == "TIE"
        ties << result
    end
    (ties.count(true) / all_games.to_f).round(2)
  end

  def seasons
    seasons = []
    game_collection.all.flat_map do |game|
       seasons << game.season
    end
    seasons
  end

  def count_of_games_by_season
    games_per_season = Hash.new(0)
    seasons.each do |season|
       games_per_season[season] += 1
     end
     games_per_season
  end

  def sum_of_all_goals
    game_collection.all.sum do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
  end

  def average_goals_per_game
    ((sum_of_all_goals / all_games.to_f) * 2).round(2)
  end

  def sum_of_goals_per_season(season)
    individual_season = game_collection.all.find_all do |game|
      game.season == season
    end
     individual_season.sum do |game|
       game.home_goals.to_i + game.away_goals.to_i
     end
  end

  #Begin league stats for Dan: highest/lowest_scoring_visitor

  def all_teams_grouped_by_away_games
    games = game_collection.all.group_by do |game|
      game.away_team_id
    end
    acc = {}
    games.each do |away_game_id, game|
      game.each do |individual_game|
        if acc[away_game_id].nil?
          old_away_goals = 0
        # elsif old_away_goals.nil?
          # old_away_goals = individual_game.away_goals.to_f
        else
          old_away_goals = individual_game.away_goals.to_f + old_away_goals
        end
        old_away_goals = old_away_goals
        acc[away_game_id] = old_away_goals
      end
    end
    # acc.each do |teams_id, away_scores|
    #   require "pry"; binding.pry
    #   acc[teams_id] = away_scores/games[teams_id].count
    acc
    require "pry"; binding.pry
  end

  def highest_scoring_away_team_id
    result = all_teams_grouped_by_away_games.max_by do |team_id, away_scores|
      away_scores
    end.first
  end

  def highest_scoring_visitor
    # method: teams_and_their_away_games # look like this
      #{first_team_id => {away_team_goals_in_first_particular_game => Game, away_team_goals_in_second_particular_game => Game}, second_team_id => {away_team}
    # method: all_teams_with_away_scores #Look like this
      #{first_team_id => total_away_goals / total_games_while_away, second_team_id => total_away ...}
    team_collection.all.find do |team|
      most_won_against_opponent(team_id) == team.team_id

    end.team_name
  end

  def most_lost_against_opponent(team_id)
    opponent_win_percentages(team_id).max_by do |opponent_id, win_rate|
      win_rate
    end.first
  end

  def rival(team_id)
    acc = team_collection.all.find do |team|
      most_lost_against_opponent(team_id) == team.team_id
    end.team_name
  end
  # End of Dan's code #

     #################START of SEASON STATS######################


     ## biggest slow down = iteration over same source of data
     ## Use memoization here as well here, Wont work super well if you have to send an arg to method
     ## how can you format this data so you dont need to reload it

     ## memoization = create an instance variable in a method set to something
     ## when called its calling that instance variable

  def team_name_based_off_of_team_id(team_id)
    team_collection_to_use.each do |team|
      return team.team_name if team_id == team.team_id
    end
  end

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

  def winningest_coach(season_id)
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
    best_coach = coaches_hash.max_by do |coach, wins|
      wins
    end
    best_coach[0]
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
    game_team_collection.all.find_all do |game_team|
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

  # end of sienna's league stats

  #stop working on stats that arent working

end
