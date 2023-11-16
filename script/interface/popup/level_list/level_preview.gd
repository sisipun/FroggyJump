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


func _ready() -> void:
	Events.game_stars_updated.connect(_on_game_stars_updated)


func init(_level_id: String, _stars: int) -> void:
	self.level_id = _level_id
	self.stars = _stars


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.is_pressed():
		emit_signal("pressed")


func _on_game_stars_updated(_level_id: String, _stars: int) -> void:
	if level_id == _level_id:
		stars = Levels.get_stars(_level_id)
