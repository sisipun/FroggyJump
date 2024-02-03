class_name LevelPreview
extends Panel


@export_node_path("Label") var _name_label_path: NodePath
@export_node_path("Label") var _stars_label_path: NodePath

@export var level_id: String

@onready var _name_label: Label = get_node(_name_label_path)
@onready var _stars_label: Label = get_node(_stars_label_path)

var stars: int:
	set(value):
		stars = value
		_stars_label.text = str(stars)
var available: bool


func _ready() -> void:
	_name_label.text = level_id
	stars = Levels.get_stars(level_id)
	available = Levels.is_available(level_id)
	
	Events.game_level_completed.connect(_on_game_level_completed)


func _gui_input(event: InputEvent) -> void:
	if available and event is InputEventScreenTouch and !event.is_pressed():
		Events.level_start_request.emit(level_id)


func _on_game_level_completed(_level_id: String, _stars: int) -> void:
	if level_id == _level_id:
		stars = Levels.get_stars(_level_id)
	if not available:
		available = Levels.is_available(level_id)
