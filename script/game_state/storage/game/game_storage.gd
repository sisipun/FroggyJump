class_name GameStorage
extends Node


@export var _save_path: String
@export var _save_file: String
@export var _current_version: String

var game: GameData = GameData.new([], "", true, true) 


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.level_completed.connect(_on_level_completed)
	Events.sound_switched.connect(_on_sound_switched)
	Events.music_switched.connect(_on_music_switched)
	
	game = _load()
	Events.game_updated.emit(game)


func _on_level_started(level_id: String) -> void:
	game.current_level_id = level_id
	_save_and_notify()


func _on_level_completed(level_id: String, stars: int) -> void:
	var levels = game.levels.filter(func(level): return level.id == level_id)
	if levels.size() == 0:
		game.levels.push_back(LevelData.new(level_id, stars))
		_save_and_notify()
	else:
		var level: LevelData = levels[0]
		level.stars = max(level.stars, stars)
		_save_and_notify()


func _on_sound_switched(value: bool) -> void:
	game.sound = value
	_save_and_notify()


func _on_music_switched(value: bool) -> void:
	game.music = value
	_save_and_notify()


func _save_and_notify() -> void:
	_save()
	Events.game_updated.emit(game)


func _load() -> GameData:
	if not FileAccess.file_exists(_save_path + _save_file):
		return game
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	var version: String = data["version"]
	if version != _current_version:
		return game
	
	return GameDataParser.read(data)


func _save() -> void:
	if not DirAccess.dir_exists_absolute(_save_path):
		DirAccess.make_dir_absolute(_save_path)
		
	var data: Dictionary = GameDataParser.write(game)
	data["version"] = _current_version
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
