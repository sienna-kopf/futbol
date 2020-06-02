class Game

  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue,
              :venue_link

  def initialize(details)
    @game_id = details[:game_id]
    @season = details[:season]
    @type = details[:type]
    @date_time = details[:date_time]
    @away_team_id = details[:away_team_id]
    @home_team_id = details[:home_team_id]
    @away_goals = details[:away_goals]
    @home_goals = details[:home_goals]
    @venue = details[:venue]
    @venue_link = details[:venue_link]
    @outcome = outcome
  end

  # The below is Dan's code (also including @outcome in initialize)
  ## megan likes these methods
  ## divy up functionality into other files outside of stat_tracker

  def outcome
    if @home_goals > @away_goals
      :home_win
    elsif @home_goals < @away_goals
      :away_win
    else
      :tie
    end
  end

  def winning_team_id
    if outcome == :home_win
      @home_team_id
    elsif outcome == :away_win
      @away_team_id
    end
  end

  def losing_team_id
    if outcome == :home_win
      @away_team_id
    elsif outcome == :away_win
      @home_team_id
    end
  end
end

# The above is Dan's code
