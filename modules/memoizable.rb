module Memoizable
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
end
