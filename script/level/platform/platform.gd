class_name Platform
extends Area2D


signal clicked(coordinates)


@export_node_path("CollisionShape2D") var _shape_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)

var coordinates: Vector2i

var jumper: Jumper = null :
	set(_jumper):
		if _jumper == null:
			jumper = null
			return
		
		jumper = _jumper
		jumper.position = position


func init(_coordinates: Vector2i, _position: Vector2, _size: Vector2) -> Platform:
	coordinates = _coordinates
	position = _position
	scale = Vector2(
		_size.x / _shape.shape.get_rect().size.x, 
		_size.y / _shape.shape.get_rect().size.y
	)
	return self


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("clicked", coordinates)


func has_jumper() -> bool:
	return jumper != null


func remove_jumper() -> void:
	jumper = null
