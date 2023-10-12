class_name GameData
extends Object


var levels: Array[LevelData]
var current_level_id: String


func _init(_levels: Array[LevelData], _current_level_id: String) -> void:
	self.levels = _levels
	self.current_level_id = _current_level_id
