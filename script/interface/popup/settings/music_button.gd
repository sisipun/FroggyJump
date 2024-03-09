class_name MusicButton
extends SwitchButton


func _ready() -> void:
	super()
	
	Events.music_switched.connect(_on_music_switched)
	
	state = Audios.is_music()


func _on_button_down() -> void:
	Events.music_switch_request.emit()
	super()


func _on_music_switched(value: bool) -> void:
	state = value
