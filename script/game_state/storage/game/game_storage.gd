class_name GameStorage
extends Node


@export var _save_path: String
@export var _save_file: String
@export var _current_version: String

var game: GameData = GameData.new([], "") 


func _ready() -> void:
	Events.level_completed.connect(_on_level_completed)
	Events.level_started.connect(_on_level_started)
	
	if not FileAccess.file_exists(_save_path + _save_file):
		Events.emit_signal("game_updated", game)
		return
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	var version: String = data["version"]
	if version == _current_version:
		game = GameDataParser.read(data)
	
	Events.emit_signal("game_updated", game)


func _on_level_started(level_id: String) -> void:
	game.current_level_id = level_id
	save()
	Events.emit_signal("game_updated", game)


func _on_level_completed(level_id: String, stars: int) -> void:
	var levels = game.levels.filter(func(level): return level.id == level_id)
	if levels.size() == 0:
		game.levels.push_back(LevelData.new(level_id, stars))
		save()
		Events.emit_signal("game_stars_updated", level_id, stars)
	else:
		var level: LevelData = levels[0]
		level.stars = max(level.stars, stars)
		save()
		Events.emit_signal("game_stars_updated", level.id, level.stars)


func save() -> void:
	if not DirAccess.dir_exists_absolute(_save_path):
		DirAccess.make_dir_absolute(_save_path)
		
	var data: Dictionary = GameDataParser.write(game)
	data["version"] = _current_version
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
