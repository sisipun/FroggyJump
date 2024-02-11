class_name LevelStorage
extends Node


class LevelStats:
	var stars: int
	var completed: bool
	
	func _init() -> void:
		stars = 0
		completed = false


@export var _levels: Array[LevelResource]

var _current_level_id: String
var _level_ids: Array[String] = []
var _id_to_resource: Dictionary = {}
var _id_to_stats: Dictionary = {}


func _ready() -> void:
	Events.game_updated.connect(_on_game_updated)
	Events.game_level_completed.connect(_on_game_level_completed)
	for level in _levels:
		_level_ids.append(level.id)
		_id_to_resource[level.id] = level
		_id_to_stats[level.id] = LevelStats.new()
	_current_level_id = _level_ids[0]


func get_resource_by_id(id: String) -> LevelResource:
	return _id_to_resource[id]


func get_model_by_id(id: String) -> LevelModel:
	var resource: LevelResource = get_resource_by_id(id)
	return LevelModel.new(
		id,
		resource.width, 
		resource.height, 
		resource.win_condition, 
		resource.get_two_star_condition(),
		resource.get_three_star_condition(),
		resource.default_cell, 
		resource.custom_cells
	) 


func get_level_ids() -> Array[String]:
	return _level_ids


func get_current_level_id() -> String:
	return _current_level_id


func get_next_level_id(id: String) -> String:
	var index: int = _level_ids.find(id)
	var next_index: int = index + 1
	if next_index == _level_ids.size():
		next_index = 0
	return _level_ids[next_index]


func get_stars(id: String) -> int:
	return _id_to_stats[id].stars


func is_available(id: String) -> bool:
	var resource: LevelResource = _id_to_resource[id]
	return resource.required_levels.all(func(it): return _id_to_stats[it].completed)


func _on_game_updated(game: GameData) -> void:
	for level in game.levels:
		_update_level_stats(level.id, level.stars, true)
	if game.current_level_id:
		_current_level_id = game.current_level_id


func _on_game_level_completed(level_id: String, stars: int) -> void:
	_update_level_stats(level_id, stars, true)


func _update_level_stats(level_id: String, stars: int, completed: bool) -> void:
	var stats: LevelStats = _id_to_stats[level_id]
	stats.stars = stars
	stats.completed = completed
