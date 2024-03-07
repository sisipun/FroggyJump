class_name SoundButton
extends SwitchButton


func _ready() -> void:
	super()
	state = state


func _on_button_down() -> void:
	Events.sound_switch_request.emit()
	state = not state
	super()
