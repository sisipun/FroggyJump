class_name LevelModel
extends Object


signal selected(x, y)
signal unselected(x, y)
signal jumper_moved(x_from, y_from, x_to, y_to)
signal jumper_hitted(x, y, current_health)
signal jumper_dead(x, y)
signal finished(won, stars)


var _width: int
var _height: int
var _win_condition: int
var _two_star_condition: int
var _three_star_condition: int
var _map: Array[Array]

var _selected_platform: PlatformModel


func _init(
	width: int, 
	height: int, 
	win_condition: int,
	two_star_condition: int,
	three_star_condition: int,
	default_cell: LevelCellResource, 
	custom_cells: Array[LevelCellCustomResource]
) -> void:
	_width = width
	_height = height
	_win_condition = win_condition
	_two_star_condition = two_star_condition
	_three_star_condition = three_star_condition
	var _custom_cells: Dictionary = {}
	for custom_cell in custom_cells:
		_custom_cells[custom_cell.coordinates] = custom_cell
	
	for x in range(width):
		_map.append([])
		for y in range(height):
			var coordinates: Vector2i = Vector2i(x, y)
			var cell: LevelCellResource = _custom_cells[coordinates] if _custom_cells.has(coordinates) else default_cell
			var jumper: JumperModel = Jumpers.get_model_by_type(coordinates, cell.jumper)
			var platform_model: PlatformModel = Platforms.get_model_by_type(coordinates, cell.platfrom)
			if platform_model != null:
				platform_model.add_jumper(jumper)
				platform_model.jumper_hitted.connect(Callable(self, "_on_jumper_hitted").bind(x, y))
				platform_model.jumper_dead.connect(Callable(self, "_on_jumper_dead").bind(x, y))
			_map[x].append(platform_model)


func is_finished() -> bool:
	for x in range(_width):
		for y in range(_height):
			if get_possible_moves(x, y) != []:
				return false
	
	return true


func is_won() -> bool:
	return get_jumpers_count() <= _win_condition


func get_stars() -> int:
	if not is_won():
		return 0
	
	var jumpers_count: int = get_jumpers_count()
	if jumpers_count <= _three_star_condition:
		return 3
	elif jumpers_count <= _two_star_condition:
		return 2
	else:
		return 1


func get_width() -> int:
	return _width


func get_height() -> int:
	return _height


func has_platform(x: int, y: int) -> bool:
	return _map[x][y] != null


func get_platform(x: int, y: int) -> PlatformModel:
	return _map[x][y]


func get_possible_moves(x: int, y: int) -> Array[Vector2i]:
	var platform: PlatformModel = _map[x][y]
	if platform == null or not platform.has_jumper():
		return []
	
	var moves: Array[Vector2i] = []
	var jumper_move_range: Array[Vector2i] = platform.get_jumper_move_range(_width, _height)
	for jumper_move in jumper_move_range:
		var move_to_platform: PlatformModel = _map[jumper_move.x][jumper_move.y]
		if move_to_platform != null and move_to_platform.can_jump_to(platform, _map):
			moves.append(jumper_move)
	
	return moves


func get_jumpers_count() -> int:
	var count: int = 0
	for x in range(_width):
		for y in range(_height):
			var platform: PlatformModel = _map[x][y]
			if platform != null and platform.has_jumper():
				count += 1
	
	return count


func select(x: int, y: int) -> void:
	if _map[x][y] == null:
		return
	
	if _selected_platform == null:
		_selected_platform = _map[x][y]
		emit_signal("selected", x, y)
		return
	
	var selected_coordinates: Vector2i = _selected_platform.get_coordinates()
	if not _try_move(selected_coordinates.x, selected_coordinates.y, x, y):
		emit_signal("unselected", selected_coordinates.x, selected_coordinates.y)
		_selected_platform = _map[x][y]
		emit_signal("selected", x, y)
		return
	
	emit_signal("unselected", selected_coordinates.x, selected_coordinates.y)
	_selected_platform = null
	if is_finished():
		emit_signal("finished", is_won(), get_stars())


func _try_move(x_from: int, y_from: int, x_to: int, y_to: int) -> bool:
	var from_platform: PlatformModel = _map[x_from][y_from]
	var to_platform: PlatformModel = _map[x_to][y_to]
	if from_platform == null or to_platform == null:
		return false
	
	var possible_moves: Array[Vector2i] = get_possible_moves(x_from, y_from)
	if to_platform.get_coordinates() not in possible_moves:
		return false
	
	var jumper: JumperModel = from_platform.get_jumper()
	from_platform.clear_jumper()
	
	var platforms_between: Array[PlatformModel] = from_platform.get_platforms_between(to_platform, _map)
	for platform_between in platforms_between:
		platform_between.hit_jumper()
	
	_map[x_to][y_to].add_jumper(jumper)
	emit_signal("jumper_moved", x_from, y_from, x_to, y_to)
	return true


func _on_jumper_hitted(x: int, y: int, current_health: int) -> void:
	emit_signal("jumper_hitted", x, y, current_health)


func _on_jumper_dead(x: int, y: int) -> void:
	emit_signal("jumper_dead", x, y)
