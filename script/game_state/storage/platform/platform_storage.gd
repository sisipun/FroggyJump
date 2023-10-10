class_name PlatformStorage
extends Node


@export var default: PlatformResource
@export var cant_jump_from: PlatformResource

@onready var _platforms: Dictionary = {
	PlatformModel.Type.DEFAULT: default,
	PlatformModel.Type.CANT_JUMP_FROM: cant_jump_from
}


func get_resource_by_type(type: PlatformModel.Type) -> PlatformResource:
	if type == PlatformModel.Type.NONE:
		return null
	
	return _platforms[type]


func get_model_by_type(coordinates: Vector2i, type: PlatformModel.Type) -> PlatformModel:
	if type == PlatformModel.Type.NONE:
		return null
	elif type == PlatformModel.Type.CANT_JUMP_FROM:
		return PlatformCantJumpFromModel.new(coordinates, type)
	
	return PlatformModel.new(coordinates, type)
