class_name MusicButton
extends SwitchButton


func _ready() -> void:
	super()
	
	pressed.connect(_on_pressed)
	Events.music_switched.connect(_on_music_switched)
	
	state = Audios.is_music()


func _on_pressed() -> void:
	Events.music_switch_request.emit()


func _on_music_switched(value: bool) -> void:
	state = value
