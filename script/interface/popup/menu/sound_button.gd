class_name SoundButton
extends SwitchButton


func _ready() -> void:
	super()
	
	pressed.connect(_on_pressed)
	Events.sound_switched.connect(_on_sound_switched)
	
	state = Audios.is_sound()


func _on_pressed() -> void:
	Events.sound_switch_request.emit()


func _on_sound_switched(value: bool) -> void:
	state = value
