class_name HomeButton
extends CommonButton


func _ready() -> void:
	super()
	
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Events.home_return_request.emit()
