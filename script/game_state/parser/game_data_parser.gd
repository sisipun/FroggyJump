class_name GameDataParser
extends Node


static func write(game: GameData) -> Dictionary:
	var levels: Array[Dictionary] = []
	for level in game.levels:
		levels.push_back(LevelDataParser.write(level))
	return {
		"levels": levels,
		"current_level_id": game.current_level_id
	}


static func read(dict: Dictionary) -> GameData:
	var levels: Array[LevelData] = []
	for level in dict["levels"]:
		levels.push_back(LevelDataParser.read(level))
	return GameData.new(
		levels,
		dict["current_level_id"]
	)
