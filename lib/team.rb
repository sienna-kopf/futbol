class Team
  attr_reader :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :link

  def initialize(team_data)
    @team_id = team_data[:team_id]
    @franchise_id = team_data[:franchiseid]
    @team_name = team_data[:teamname]
    @abbreviation = team_data[:abbreviation]
    @link = team_data[:link]
  end

  #team details methods 
end
