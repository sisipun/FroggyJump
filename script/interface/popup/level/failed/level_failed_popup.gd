class_name LevelFailedPopup
extends CommonPopup


@export_node_path("AudioStreamPlayer") var _sound_player_path: NodePath

@onready var _sound_player: AudioStreamPlayer = get_node(_sound_player_path)


func show_popup() -> void:
	_sound_player.play()
	super()
