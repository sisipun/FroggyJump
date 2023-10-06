class_name PlatformStorage
extends Node


enum PlatformType {
	DEFAULT,
	CANT_JUMP_FROM,
	CANT_JUMP_TO
}


@export var default: PlatformResource
@export var cant_jump_from: PlatformResource
@export var cant_jump_to: PlatformResource

@onready var _platforms: Dictionary = {
	PlatformType.DEFAULT: default,
	PlatformType.CANT_JUMP_FROM: cant_jump_from,
	PlatformType.CANT_JUMP_TO: cant_jump_to
}


func get_by_type(type: PlatformType) -> PlatformResource:
	return _platforms[type]


func get_model_by_type(coordinates: Vector2i, type: PlatformType) -> PlatformModel:
	return PlatformModel.new(coordinates)
