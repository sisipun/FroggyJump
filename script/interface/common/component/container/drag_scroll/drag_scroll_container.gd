class_name DragScrollContainer
extends ScrollContainer


signal vertical_scroll(old_value, new_value)
signal horizontal_scroll(old_value, new_value)


@export var vertical_scroll_enabled: bool = true
@export var horizontal_scroll_enabled: bool = true

var last_scroll_vertical: int
var last_scroll_horizontal: int


func _ready() -> void:
	last_scroll_vertical = scroll_vertical
	last_scroll_horizontal = scroll_horizontal


func _process(_delta: float) -> void:
	if scroll_vertical != last_scroll_vertical:
		vertical_scroll.emit(last_scroll_vertical, scroll_vertical)
		last_scroll_vertical = scroll_vertical
	
	if scroll_horizontal != last_scroll_horizontal:
		horizontal_scroll.emit(last_scroll_horizontal, scroll_horizontal)
		last_scroll_horizontal = scroll_horizontal


func set_scroll_vertical(value: int) -> void:
	scroll_vertical = value
	last_scroll_vertical = value


func set_scroll_horizontal(value: int) -> void:
	scroll_horizontal = value
	last_scroll_horizontal = value
