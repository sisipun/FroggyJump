class_name DragScrollContainer
extends ScrollContainer


signal vertical_scroll(old_value, new_value)
signal horizontal_scroll(old_value, new_value)


@export var vertical_scroll_enabled: bool = true
@export var horizontal_scroll_enabled: bool = true


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if vertical_scroll_enabled:
			var old_value: int = scroll_vertical
			scroll_vertical -= event.relative.y
			vertical_scroll.emit(old_value, scroll_vertical)
		if horizontal_scroll_enabled:
			var old_value: int = scroll_horizontal
			scroll_horizontal -= event.relative.x
			horizontal_scroll.emit(old_value, scroll_horizontal)
