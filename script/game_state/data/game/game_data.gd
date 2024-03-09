class_name GameData
extends Object


var levels: Array[LevelData]
var current_level_id: String
var sound: bool
var music: bool


func _init(
	_levels: Array[LevelData], 
	_current_level_id: String, 
	_sound: bool,
	_music: bool
) -> void:
	levels = _levels
	current_level_id = _current_level_id
	sound = _sound
	music = _music
