class_name SoundButton
extends SwitchButton


func _ready() -> void:
	super()
	
	Events.sound_switched.connect(_on_sound_switched)
	
	state = Audios.is_sound()


func _on_button_down() -> void:
	Events.sound_switch_request.emit()
	super()


func _on_sound_switched(value: bool) -> void:
	state = value
