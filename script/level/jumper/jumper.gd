class_name Jumper
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("AnimatedSprite2D") var _body_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _body: AnimatedSprite2D = get_node(_body_path)

var jump_distance: int
var health: int


func init(_size: Vector2, _jump_distance: int, _health: int, body: SpriteFrames) -> Jumper:
	scale = Vector2(
		_size.x / _shape.shape.get_rect().size.x, 
		_size.y / _shape.shape.get_rect().size.y
	)
	jump_distance = _jump_distance
	health = _health
	_body.sprite_frames = body
	return self
