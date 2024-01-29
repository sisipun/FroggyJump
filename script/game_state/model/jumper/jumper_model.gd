class_name JumperModel
extends Object


enum Type {
	NONE,
	DEFAULT,
	FAST,
	BIG
}


signal hitted(current_health)
signal dead


var _coordinates: Vector2i
var _type: Type
var _jump_distance: int
var _health: int


func _init(coordinates: Vector2i, type: Type, jump_distance: int, health: int) -> void:
	_coordinates = coordinates
	_type = type
	_jump_distance = jump_distance
	_health = health


func get_coordinates() -> Vector2i:
	return _coordinates


func get_type() -> Type:
	return _type


func get_jump_distance() -> int:
	return _jump_distance


func get_health() -> int:
	return _health


func get_move_range(map_width: int, map_height: int) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	for i in range(_jump_distance):
		var new_x_pos: int = _coordinates.x + (i + 2)
		var new_x_neg: int = _coordinates.x - (i + 2)
		var new_y_pos: int = _coordinates.y + (i + 2)
		var new_y_neg: int = _coordinates.y - (i + 2)
		if new_x_pos < map_width: 
			moves.append(Vector2i(new_x_pos, _coordinates.y))
		if new_x_neg >= 0:
			moves.append(Vector2i(new_x_neg, _coordinates.y))
		if new_y_pos < map_height:
			moves.append(Vector2i(_coordinates.x, new_y_pos))
		if new_y_neg >= 0:
			moves.append(Vector2i(_coordinates.x, new_y_neg))
	return moves


func move_to(coordinates: Vector2i) -> void:
	_coordinates = coordinates


func hit() -> void:
	_health -= 1
	if _health > 0:
		hitted.emit(_health)
	else:
		dead.emit()
