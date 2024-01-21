class_name LevelPreview
extends Panel


signal pressed


@export_node_path("Label") var _name_label_path: NodePath
@export_node_path("Label") var _stars_label_path: NodePath

@onready var _name_label: Label = get_node(_name_label_path)
@onready var _stars_label: Label = get_node(_stars_label_path)

var level_id: String:
	set(value):
		level_id = value
		_name_label.text = level_id
var stars: int:
	set(value):
		stars = value
		_stars_label.text = str(stars)
var enabled: bool


func _ready() -> void:
	Events.game_level_completed.connect(_on_game_level_completed)


func init(_level_id: String, _stars: int) -> void:
	level_id = _level_id
	stars = _stars
	enabled = Levels.is_enabled(level_id)


func _gui_input(event: InputEvent) -> void:
	if enabled and event is InputEventScreenTouch and !event.is_pressed():
		emit_signal("pressed")


func _on_game_level_completed(_level_id: String, _stars: int) -> void:
	if level_id == _level_id:
		stars = Levels.get_stars(_level_id)
	if not enabled:
		enabled = Levels.is_enabled(level_id)
