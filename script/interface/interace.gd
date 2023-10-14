class_name Interface
extends Control


@export_node_path("LevelCompletePopup") var _level_complete_popup_path: NodePath

var _level_complete_popup: LevelCompletePopup


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.level_completed.connect(_on_level_completed)
	
	_level_complete_popup = get_node(_level_complete_popup_path)


func _on_level_started(_level_id: String) -> void:
	_level_complete_popup.hide()


func _on_level_completed(_level_id: String) -> void:
	_level_complete_popup.show()
