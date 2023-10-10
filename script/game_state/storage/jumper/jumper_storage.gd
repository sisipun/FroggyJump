class_name JumperStorage
extends Node


@export var default: JumperResource
@export var fast: JumperResource
@export var big: JumperResource

@onready var _jumpers: Dictionary = {
	JumperModel.Type.DEFAULT: default,
	JumperModel.Type.FAST: fast,
	JumperModel.Type.BIG: big
}


func get_resource_by_type(type: JumperModel.Type) -> JumperResource:
	if type == JumperModel.Type.NONE:
		return null
	return _jumpers[type]


func get_model_by_type(coordinates: Vector2i, type: JumperModel.Type) -> JumperModel:
	if type == JumperModel.Type.NONE:
		return null
	
	var resource: JumperResource = get_resource_by_type(type)
	return JumperModel.new(coordinates, type, resource.jump_distance, resource.health)
