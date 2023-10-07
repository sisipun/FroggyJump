class_name LevelModel
extends Object


var _width: int
var _height: int
var _win_condition: int
var _map: Array[Array]


func _init(width: int, height: int, win_condition: int, default_cell: LevelCellResource, custom_cells: Array[LevelCellCustomResource]) -> void:
	_width = width
	_height = height
	_win_condition = win_condition
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
			platform_model.add_jumper(jumper)
			_map[x].append(platform_model)
