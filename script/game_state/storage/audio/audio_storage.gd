class_name AudioStorage
extends Node


var sound_bus_name: String = "Sound"
var music_bus_name: String = "Music"

var sound_bus_index: int
var music_bus_index: int


func _ready() -> void:
	Events.game_updated.connect(_on_game_updated)
	Events.sound_switch_request.connect(_on_sound_switch_request)
	Events.music_switch_request.connect(_on_muisc_switch_request)
	
	sound_bus_index = AudioServer.get_bus_index(sound_bus_name)
	music_bus_index = AudioServer.get_bus_index(music_bus_name)


func is_sound() -> bool:
	return not AudioServer.is_bus_mute(sound_bus_index)


func is_music() -> bool:
	return not AudioServer.is_bus_mute(music_bus_index)


func _on_game_updated(game: GameData) -> void:
	if is_sound() != game.sound:
		_set_bus(sound_bus_index, game.sound)
	if is_music() != game.music:
		_set_bus(music_bus_index, game.music)


func _on_sound_switch_request() -> void:
	var value: bool = not is_sound()
	_set_bus(sound_bus_index, value)
	Events.sound_switched.emit(value)


func _on_muisc_switch_request() -> void:
	var value: bool = not is_music()
	_set_bus(music_bus_index, value)
	Events.music_switched.emit(value)


func _set_bus(bus_index: int, value: bool) -> void:
	AudioServer.set_bus_mute(bus_index, not value)
