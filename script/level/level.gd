class_name Level
extends Area2D


@export_node_path("CollisionShape2D") var _spawn_area_path: NodePath
@export_node_path("Node2D") var _platforms_path: NodePath
@export_node_path("Node2D") var _jumpers_path: NodePath
@export var _jumper_scene: PackedScene
@export var _platform_scene: PackedScene

@export var _level_size: Vector2i
@export var _platform_margin: Vector2 

@onready var _spawn_area: CollisionShape2D = get_node(_spawn_area_path)
@onready var _platforms: Node2D = get_node(_platforms_path)
@onready var _jumpers: Node2D = get_node(_jumpers_path)

var _platform_map: Array[Array] = []
var _clicked_platform: Platform = null
var _clicked_possible_moves: Array[Vector2i] = []


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	var spawn_area_size: Vector2 = _spawn_area.shape.b - _spawn_area.shape.a
	var level_size: Vector2 = Vector2(_level_size.x, _level_size.y)
	var platform_size: Vector2 = (spawn_area_size - _platform_margin * (level_size + Vector2(1, 1))) / level_size
	var jumper_size: Vector2 = platform_size / 2.0
	
	_platform_map.clear()
	for x in range(_level_size.x):
		_platform_map.append([])
		for y in range(_level_size.y):
			var spawn_position = _spawn_area.shape.a + _platform_margin + (platform_size / 2) + Vector2(x, y) * (_platform_margin + platform_size)
			var spawn_coordinates = Vector2i(x, y)
			var platform: Platform = _platform_scene.instantiate()
			_platforms.add_child(platform)
			platform.init(spawn_coordinates, spawn_position, platform_size)
			platform.clicked.connect(_on_platform_clicked)
			
			if x != y:
				var jumper: Jumper = _jumper_scene.instantiate()
				_jumpers.add_child(jumper)
				jumper.init(jumper_size, 2)
				platform.jumper = jumper
			
			_platform_map[x].append(platform)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_platform_clicked(coordinates: Vector2i) -> void:
	if _clicked_platform == null or not _clicked_platform.has_jumper():
		_set_clicked(coordinates)
		return
	
	var platform: Platform = _platform_map[coordinates.x][coordinates.y]
	if platform.has_jumper() or coordinates not in _clicked_possible_moves:
		_set_clicked(coordinates)
		return
	
	var clicked_coordinates: Vector2i = _clicked_platform.coordinates
	var clicked_jumper: Jumper = _clicked_platform.jumper
	
	_clicked_platform.remove_jumper()
	_clear_clicked()
	
	for x in range(min(clicked_coordinates.x, coordinates.x) + 1, max(clicked_coordinates.x, coordinates.x)):
		var platform_between: Platform = _platform_map[x][clicked_coordinates.y]
		if platform_between.has_jumper():
			var jummer_between: Jumper = platform_between.jumper
			platform_between.remove_jumper()
			jummer_between.queue_free()
	
	for y in range(min(clicked_coordinates.y, coordinates.y) + 1, max(clicked_coordinates.y, coordinates.y)):
		var platform_between: Platform = _platform_map[clicked_coordinates.x][y]
		if platform_between.has_jumper():
			var jummer_between: Jumper = platform_between.jumper
			platform_between.remove_jumper()
			jummer_between.queue_free()
	
	platform.jumper = clicked_jumper


func _set_clicked(coordinates: Vector2i) -> void:
	if _clicked_platform != null:
		_clear_clicked()
	
	_clicked_platform = _platform_map[coordinates.x][coordinates.y]
	_clicked_platform.show_as_current()
	
	_clicked_possible_moves = _get_possible_moves(_clicked_platform.coordinates)
	for move in _clicked_possible_moves:
		_platform_map[move.x][move.y].show_as_possible_move()


func _clear_clicked() -> void:
	_clicked_platform.show_as_default()
	
	for move in _clicked_possible_moves:
		_platform_map[move.x][move.y].show_as_default()
	
	_clicked_platform = null
	_clicked_possible_moves.clear()


func _get_possible_moves(coordinates: Vector2i) -> Array[Vector2i]:
	var platform: Platform = _platform_map[coordinates.x][coordinates.y]
	if not platform.has_jumper():
		return []
	
	var jumper: Jumper = platform.jumper
	var jump_distance: int = jumper.jump_distance
	
	return (
		_get_line_possible_moves(coordinates, jump_distance, 1, 0) 
		+ _get_line_possible_moves(coordinates, jump_distance, 0, 1) 
		+ _get_line_possible_moves(coordinates, jump_distance, -1, 0) 
		+  _get_line_possible_moves(coordinates, jump_distance, 0, -1)
	)


func _get_line_possible_moves(
	coordinates: Vector2i, 
	jump_distance: int, 
	x_mul: int, 
	y_mul: int
) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var has_jumper: bool = false
	for i in range(jump_distance + 1):
		var new_x: int = coordinates.x + (x_mul * (i + 1))
		var new_y: int = coordinates.y + (y_mul * (i + 1))
		if new_x >= _platform_map.size() or new_x < 0 or new_y >= _platform_map[0].size() or new_y < 0:
			continue
		if _platform_map[new_x][new_y].has_jumper():
			has_jumper = true
			continue
		if has_jumper:
			moves.append(Vector2i(new_x, new_y))
	
	return moves
