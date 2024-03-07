class_name BackgroundMusicPlayer
extends AudioStreamPlayer


@export var menu: AudioStream
@export var level: AudioStream


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.home_returned.connect(_on_home_returned)
	_play_menu()


func _on_level_started(_level_id: String) -> void:
	_play_level()


func _on_home_returned() -> void:
	_play_menu()


func _play_menu() -> void:
	if stream != menu:
		stop()
		stream = menu
		play()


func _play_level() -> void:
	if stream != level:
		stop()
		stream = level
		play()
