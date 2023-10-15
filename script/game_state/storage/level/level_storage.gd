class_name LevelStorage
extends Node


@export var _levels: Array[LevelResource]

var _current_level_id: String
var _id_to_level: Dictionary = {}
var _level_ids: Array[String] = []


func _ready() -> void:
	Events.game_updated.connect(_on_game_updated)
	for level in _levels:
		_id_to_level[level.id] = level
		_level_ids.append(level.id)
	_current_level_id = Games.game.current_level_id if Games.game.current_level_id else _level_ids[0]


func get_resource_by_id(id: String) -> LevelResource:
	return _id_to_level[id]


func get_model_by_id(id: String) -> LevelModel:
	var resource: LevelResource = get_resource_by_id(id)
	return LevelModel.new(resource.width, resource.height, resource.win_condition, resource.default_cell, resource.custom_cells)


func get_next_level_id(id: String) -> String:
	var index: int = _level_ids.find(id)
	var next_index: int = index + 1
	if next_index == _level_ids.size():
		next_index = 0
	return _level_ids[next_index]


func get_level_ids() -> Array[String]:
	return _level_ids


func get_current_level_id() -> String:
	return _current_level_id


func _on_game_updated(game: GameData) -> void:
	_current_level_id = game.current_level_id
