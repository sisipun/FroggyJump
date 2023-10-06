class_name JumperStorage
extends Node


enum JumperType {
	DEFAULT,
	FAST,
	BIG
}


@export var default: JumperResource
@export var fast: JumperResource
@export var big: JumperResource

@onready var _jumpers: Dictionary = {
	JumperType.DEFAULT: default,
	JumperType.FAST: fast,
	JumperType.BIG: big
}


func get_resource_by_type(type: JumperType) -> JumperResource:
	return _jumpers[type]


func get_model_by_type(coordinates: Vector2i, type: JumperType) -> JumperModel:
	var resource: JumperResource = get_resource_by_type(type)
	return JumperModel.new(coordinates, resource.jump_distance, resource.health)
