class_name LevelHud
extends Control


@export_node_path("Label") var _level_goal_label_path: NodePath

@onready var _level_goal_label: Label = get_node(_level_goal_label_path)


func _ready() -> void:
	Events.level_goal_changed.connect(_on_level_goal_changed)


func _on_level_goal_changed(jumpers_count: int, jumpers_goal: int, stars_count: int) -> void:
	_level_goal_label.text = "%d - %d/%d" % [stars_count, jumpers_count, jumpers_goal]
