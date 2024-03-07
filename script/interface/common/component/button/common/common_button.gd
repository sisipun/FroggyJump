class_name CommonButton
extends TextureButton


@export_node_path("AnimationPlayer") var _animation_player_path: NodePath
@export_node_path("AudioStreamPlayer") var _audio_stream_player_path: NodePath

@onready var _animation_player: AnimationPlayer = get_node(_animation_player_path)
@onready var _audio_stream_player: AudioStreamPlayer = get_node(_audio_stream_player_path)


func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)


func _on_button_down() -> void:
	_animation_player.play("down")
	_audio_stream_player.play()


func _on_button_up() -> void:
	_animation_player.play("up")
