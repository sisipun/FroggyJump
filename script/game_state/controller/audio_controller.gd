class_name AudioController
extends Node


var sound_bus_name: String = "Sound"
var music_bus_name: String = "Music"


func _ready() -> void:
	Events.sound_switch_request.connect(_on_sound_switch_request)
	Events.music_switch_request.connect(_on_muisc_switch_request)


func _on_sound_switch_request() -> void:
	var bus_index: int = AudioServer.get_bus_index(sound_bus_name)
	AudioServer.set_bus_mute(bus_index, not AudioServer.is_bus_mute(bus_index))


func _on_muisc_switch_request() -> void:
	var bus_index: int = AudioServer.get_bus_index(music_bus_name)
	AudioServer.set_bus_mute(bus_index, not AudioServer.is_bus_mute(bus_index))
