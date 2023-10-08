class_name PlatformStorage
extends Node


@export var default: PlatformResource
@export var cant_jump_from: PlatformResource
@export var cant_jump_to: PlatformResource

@onready var _platforms: Dictionary = {
	PlatformModel.Type.DEFAULT: default,
	PlatformModel.Type.CANT_JUMP_FROM: cant_jump_from,
	PlatformModel.Type.CANT_JUMP_TO: cant_jump_to
}


func get_by_type(type: PlatformModel.Type) -> PlatformResource:
	if type == PlatformModel.Type.NONE:
		return null
	
	return _platforms[type]


func get_model_by_type(coordinates: Vector2i, type: PlatformModel.Type) -> PlatformModel:
	if type == PlatformModel.Type.NONE:
		return null
	
	return PlatformModel.new(coordinates, type)
