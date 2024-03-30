class_name SettingsPopup
extends Control


@export_node_path("ColorRect") var _background_path: NodePath
@export_node_path("CommonButton") var _home_button_path: NodePath
@export_node_path("CommonButton") var _close_button_path: NodePath

@onready var _background: ColorRect = get_node(_background_path)
@onready var _home_button: CommonButton = get_node(_home_button_path)
@onready var _close_button: CommonButton = get_node(_close_button_path)


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.home_returned.connect(_on_home_returned)
	
	_close_button.pressed.connect(_on_close_button_pressed)
	_background.gui_input.connect(_on_background_input)


func _on_level_started(_level_id: String) -> void:
	_home_button.show()


func _on_home_returned() -> void:
	_home_button.hide()


func _on_background_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_on_close()


func _on_close_button_pressed() -> void:
	_on_close()


func _on_close() -> void:
	hide()
