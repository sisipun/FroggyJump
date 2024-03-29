class_name LevelCompletePopup
extends Control


# TODO use preseted buttons
@export_node_path("Button") var _next_button_path: NodePath
@export_node_path("Button") var _restart_button_path: NodePath
@export_node_path("Button") var _home_button_path: NodePath

@onready var _next_button: Button = get_node(_next_button_path)
@onready var _restart_button: Button = get_node(_restart_button_path)
@onready var _home_buttom: Button = get_node(_home_button_path)


func _ready() -> void:
	_next_button.pressed.connect(_on_next_button_pressed)
	_restart_button.pressed.connect(_on_restart_button_pressed)
	_home_buttom.pressed.connect(_on_home_buttom_pressed)


func _on_next_button_pressed() -> void:
	Events.level_start_request.emit(Levels.get_next_level_id(Levels.get_current_level_id()))


func _on_restart_button_pressed() -> void:
	Events.level_start_request.emit(Levels.get_current_level_id())


func _on_home_buttom_pressed() -> void:
	Events.home_return_request.emit()
