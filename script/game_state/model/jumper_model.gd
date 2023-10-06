class_name JumperModel
extends Object


signal hitted(current_health)
signal dead


var _coordinates: Vector2i
var _jump_distance: int
var _health: int


func _init(coordinates: Vector2i, jump_distance: int, health: int) -> void:
	_coordinates = coordinates
	_jump_distance = jump_distance
	_health = health


func get_coordinates() -> Vector2i:
	return _coordinates


func get_possible_moves() -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	for i in range(_jump_distance):
		moves.append(Vector2i(_coordinates.x + (i + 2), _coordinates.y))
		moves.append(Vector2i(_coordinates.x, _coordinates.y + (i + 2)))
		moves.append(Vector2i(_coordinates.x - (i + 2), _coordinates.y))
		moves.append(Vector2i(_coordinates.x, _coordinates.y - (i + 2)))
	return moves


func move_to(coordinates: Vector2i) -> void:
	_coordinates = coordinates


func hit() -> void:
	_health -= 1
	if _health > 0:
		emit_signal("hitted", _health)
	else:
		emit_signal("dead")
