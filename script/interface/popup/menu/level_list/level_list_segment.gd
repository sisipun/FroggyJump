class_name LevelListSegment
extends Control


@export_node_path("Control") var _previews_node_path

@onready var _previews: Control = get_node(_previews_node_path)


func is_available() -> bool:
	return _previews.get_children().any(func(it: LevelPreview): return it.available)
