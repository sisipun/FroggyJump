class_name DragScrollContainer
extends ScrollContainer


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		scroll_vertical -= event.relative.y
