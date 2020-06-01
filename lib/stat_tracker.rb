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

  def highest_total_score
    total = game_collection.all.max_by do |game|
      game.away_goals + game.home_goals
    end
    total.home_goals + total.away_goals
  end

  def lowest_total_score
    total = game_collection.all.min_by do |game|
      game.away_goals + game.home_goals
    end
    total.home_goals + total.away_goals
  end


##################### Beginning of League section #####################

  def count_of_teams(team)
    teams.count
  end

  def best_offense
    team_id =

  end

  def worst_offense
    team_id =

  end

  def highest_scoring_visitor
    team_id =

  end

  def highest_scoring_home_team
    team_id = 

  end

  def lowest_scoring_visitor
    #Name of the team with the lowest average score per game across all seasons when they are a visitor.

  end

  def lowest_scoring_home_team
    #Name of the team with the lowest average score per game across all seasons when they are at home.

  end

end
