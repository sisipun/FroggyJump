class_name RestartLevelButton
extends CommonButton


func _ready() -> void:
	super()
	
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Events.level_start_request.emit(Levels.get_current_level_id())
