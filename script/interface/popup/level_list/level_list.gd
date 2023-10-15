class_name LevelList
extends VBoxContainer


@export var level_preview_scene: PackedScene


func _ready() -> void:
	for level_id in Levels.get_level_ids():
		var level_preview: LevelPreview = level_preview_scene.instantiate()
		add_child(level_preview)
		level_preview.init(level_id)
		level_preview.pressed.connect(Callable(_on_level_pressed).bind(level_preview))


func _on_level_pressed(preview: LevelPreview) -> void:
	Events.emit_signal("level_start_request", preview.level_id)
