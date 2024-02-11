class_name Jumper
extends Area2D


signal movement_finished


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("AnimatedSprite2D") var _body_path: NodePath

@export var _speed: float = 30.0

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _body: AnimatedSprite2D = get_node(_body_path)

var jump_distance: int
var health: int
var move_to_position: Vector2


func init(
	_size: Vector2, 
	_jump_distance: int, 
	_health: int, 
	_sprite_frames: SpriteFrames
) -> Jumper:
	scale = Vector2(
		_size.x / _shape.shape.get_rect().size.x, 
		_size.y / _shape.shape.get_rect().size.y
	)
	jump_distance = _jump_distance
	health = _health
	_body.sprite_frames = _sprite_frames
	move_to_position = position
	return self


func _physics_process(_delta: float) -> void:
	var distance: float = move_to_position.distance_to(position)
	var velocity: Vector2 = (move_to_position - position).normalized() * _speed
	var new_position: Vector2 = position + velocity
	var new_distance: float = move_to_position.distance_to(new_position)
	
	if distance < new_distance:
		position = move_to_position
		set_physics_process(false)
		movement_finished.emit()
	else:
		position = new_position


func move_to(new_position: Vector2, initial: bool) -> void:
	if initial:
		position = new_position 
	
	move_to_position = new_position
	if move_to_position != position:
		set_physics_process(true)
