class_name PlatformModel
extends Object


signal jumper_hitted(current_health)
signal jumper_dead


enum Type {
	NONE,
	DEFAULT,
	CANT_JUMP_FROM,
	CANT_JUMP_TO
}


var _coordinates: Vector2i
var _type: Type
var _jumper: JumperModel


func _init(coordinates: Vector2i, type: Type) -> void:
	_coordinates = coordinates
	_type = type


func has_jumper() -> bool:
	return _jumper != null


func can_jump_to(jump_from: PlatformModel, map: Array[Array]) -> bool:
	return not has_jumper() and not get_jumpers_between(jump_from, map).is_empty()


func get_coordinates() -> Vector2i:
	return _coordinates


func get_type() -> Type:
	return _type


func get_jumper() -> JumperModel:
	return _jumper


func get_jumper_move_range(map_width: int, map_height: int) -> Array[Vector2i]:
	if not has_jumper():
		return []
	
	return _jumper.get_move_range(map_width, map_height)


func get_jumpers_between(plaftorm: PlatformModel, map: Array[Array]) -> Array[JumperModel]:
	var jumpers: Array[JumperModel] = []
	var distance: Vector2i = _coordinates - plaftorm.get_coordinates()
	var distance_max: int = max(abs(distance.x), abs(distance.y))
	if distance_max == 0:
		return []
	
	var step: Vector2i = distance / distance_max
	var check_path: Vector2i = plaftorm.get_coordinates() + step
	while check_path != _coordinates:
		var platform_between: PlatformModel = map[check_path.x][check_path.y]
		if platform_between.has_jumper():
			jumpers.append(platform_between.get_jumper())
		check_path += step
	return jumpers


func add_jumper(jumper: JumperModel) -> void:
	_jumper = jumper
	
	if _jumper != null:
		_jumper.move_to(_coordinates)
		_jumper.hitted.connect(_on_jumper_hitted)
		_jumper.dead.connect(_on_jumper_dead)


func clear_jumper() -> void:
	_jumper.hitted.disconnect(_on_jumper_hitted)
	_jumper.dead.disconnect(_on_jumper_dead)
	_jumper = null


func _on_jumper_hitted(current_health: int) -> void:
	emit_signal("jumper_hitted", current_health)


func _on_jumper_dead() -> void:
	emit_signal("jumper_dead")
	clear_jumper()
