class_name Game
extends Node


func _ready() -> void:
	Events.emit_signal("level_start_request", Levels.get_current_level_id())
