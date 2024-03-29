class_name SettignsButton
extends CommonButton


func _ready() -> void:
	super()
	
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Events.settings_show_request.emit()
