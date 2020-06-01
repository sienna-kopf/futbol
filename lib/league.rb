require 'csv'
class League


  def initialize(league_data)
    @season = league_data[:season].to_s
    @away_team_id = league_data[:away_team_id].to_i
    @home_team_id = league_data[:home_team_id].to_i
    @away_goals = league_data[:away_goals]
    @home_goals = league_data[:home_goals]
  end

end
