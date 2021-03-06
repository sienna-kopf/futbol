class GameTeam ### clean out data that is not necessary to store
  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :power_play_opportunities,
              :power_play_goals,
              :face_off_win_percentage,
              :giveaways,
              :takeaways

  def initialize(game_teams_data)
    @game_id = game_teams_data[:game_id]
    @team_id = game_teams_data[:team_id]
    @hoa = game_teams_data[:hoa]
    @result = game_teams_data[:result]
    @settled_in = game_teams_data[:settled_in]
    @head_coach = game_teams_data[:head_coach]
    @goals = game_teams_data[:goals]
    @shots = game_teams_data[:shots]
    @tackles = game_teams_data[:tackles]
    @pim = game_teams_data[:pim]
    @power_play_opportunities = game_teams_data[:power_play_opportunities]
    @power_play_goals = game_teams_data[:power_play_goals]
    @face_off_win_percentage = game_teams_data[:face_off_win_percentage]
    @giveaways = game_teams_data[:giveaways]
    @takeaways = game_teams_data[:takeaways]
    ## not loading unecessary data might be a good idea!
  end
end
