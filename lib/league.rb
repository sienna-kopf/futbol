require 'csv'
class League

  attr_reader :season,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,

  def initialize(league_data)
    @season = league_data[:season].to_s
    @away_team_id = league_data[:away_team_id].to_i
    @home_team_id = league_data[:home_team_id].to_i
    @away_goals = league_data[:away_goals]
    @home_goals = league_data[:home_goals]
  end

end









  end





end
