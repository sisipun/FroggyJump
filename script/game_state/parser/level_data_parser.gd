class_name LevelDataParser
extends Node


static func write(song: LevelData) -> Dictionary:
	return {
		"id" : song.id
	}



static func read(dict: Dictionary) -> LevelData:
	return LevelData.new(
		dict["id"]
	)
