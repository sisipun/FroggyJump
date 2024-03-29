class_name Game
extends Node


func _ready() -> void:
	Events.home_return_request.emit()
