class_name Interface
extends Control


@export_node_path("LevelCompletePopup") var _level_complete_popup_path: NodePath
@export_node_path("LevelListPopup") var _level_list_popup_path: NodePath

var _level_complete_popup: LevelCompletePopup
var _level_list_popup: LevelListPopup


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.level_completed.connect(_on_level_completed)
	Events.home_return_request.connect(_on_home_return_request)
	
	_level_complete_popup = get_node(_level_complete_popup_path)
	_level_list_popup = get_node(_level_list_popup_path)


func _on_level_started(_level_id: String) -> void:
	_level_complete_popup.hide()
	_level_list_popup.hide()


func _on_level_completed(_level_id: String, _stars: int) -> void:
	_level_complete_popup.show()


func _on_home_return_request() -> void:
	_level_complete_popup.hide()
	_level_list_popup.show()
