class_name PlatformModel
extends Object


var _coordinates: Vector2i
var _jumper: JumperModel


func _init(coordinates: Vector2i) -> void:
	_coordinates = coordinates


func has_jumper() -> bool:
	return _jumper != null


func can_jump_to(jump_from: PlatformModel, map: Array[Array]) -> bool:
	var distance: Vector2i = _coordinates - jump_from.get_coordinates()
	var step: Vector2i = _coordinates / max(distance.x, distance.y)
	var check_path: Vector2i = jump_from.get_coordinates() + step
	while check_path != _coordinates:
		if map[check_path.x][check_path.y].has_jumper():
			return true
	return false


func get_coordinates() -> Vector2i:
	return _coordinates


func get_possible_moves() -> Array[Vector2i]:
	if not has_jumper():
		return []
	
	return _jumper.get_possible_moves()


func add_jumper(jumper: JumperModel) -> void:
	_jumper = jumper


func clear_jumper() -> void:
	_jumper = null
