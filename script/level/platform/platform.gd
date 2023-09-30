class_name Platform
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)


func init(
	_position: Vector2, 
	_size: Vector2, 
) -> Platform:
	position = _position
	scale = Vector2(
		_size.x / _shape.shape.get_rect().size.x, 
		_size.y / _shape.shape.get_rect().size.y
	)
	return self
