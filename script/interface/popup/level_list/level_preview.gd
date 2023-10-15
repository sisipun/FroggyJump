class_name LevelPreview
extends Panel


signal pressed


@export_node_path("Label") var _name_label_path: NodePath

@onready var _name_label: Label = get_node(_name_label_path)

var level_id: String


func init(_level_id: String) -> void:
	self.level_id = _level_id
	_name_label.text = level_id


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and !event.is_pressed():
		emit_signal("pressed")
