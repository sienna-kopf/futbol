class Season



  def team_name_based_off_of_team_id(team_id)
    @stat_tracker.team_collection_to_use.each do |team|
      return team.team_name if team_id == team.team_id
    end
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

  def total_season_tackles_grouped_by_team(season_id)
    tackles_for_season_by_team = Hash.new(0)
    game_teams_by_season(season_id).each do |game_team|
      tackles_for_season_by_team[game_team.team_id] += game_team.tackles.to_i
    end
    tackles_for_season_by_team
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

end
