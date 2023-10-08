class_name Jumper
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)

var jump_distance: int
var health: int


func init(_size: Vector2, _jump_distance: int, _health: int) -> Jumper:
	scale = Vector2(
		_size.x / _shape.shape.get_rect().size.x, 
		_size.y / _shape.shape.get_rect().size.y
	)
	jump_distance = _jump_distance
	health = _health
	return self
