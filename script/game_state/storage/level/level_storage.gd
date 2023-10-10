class_name LevelStorage
extends Node


@export var _levels: Array[LevelResource]

var _id_to_level: Dictionary = {}


func _ready() -> void:
	for level in _levels:
		_id_to_level[level.id] = level


func get_resource_by_id(id: String) -> LevelResource:
	return _id_to_level[id]


func get_model_by_id(id: String) -> LevelModel:
	var resource: LevelResource = get_resource_by_id(id)
	return LevelModel.new(resource.width, resource.height, resource.win_condition, resource.default_cell, resource.custom_cells)
