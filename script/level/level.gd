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
				jumper.init(jumper_size)
				platform.jumper = jumper
			
			_platform_map[x].append(platform)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_platform_clicked(coordinates: Vector2i) -> void:
	if _clicked_platform == null or not _clicked_platform.has_jumper():
		_clicked_platform = _platform_map[coordinates.x][coordinates.y]
		return
	
	var platform: Platform = _platform_map[coordinates.x][coordinates.y]
	var coordimates_diff: Vector2i = _clicked_platform.coordinates - coordinates
	if platform.has_jumper() or abs(coordimates_diff) not in [Vector2i(2, 0), Vector2i(0, 2)]:
		_clicked_platform = _platform_map[coordinates.x][coordinates.y]
		return
	
	var cordinates_between: Vector2i = coordinates + (coordimates_diff / 2)
	var platform_between: Platform = _platform_map[cordinates_between.x][cordinates_between.y]
	if not platform_between.has_jumper():
		_clicked_platform = _platform_map[coordinates.x][coordinates.y]
		return
	
	var jummer_between: Jumper = platform_between.jumper
	var clicked_jumper: Jumper = _clicked_platform.jumper
	
	_clicked_platform.remove_jumper()
	_clicked_platform = null
	
	platform_between.remove_jumper()
	jummer_between.queue_free()
	
	platform.jumper = clicked_jumper
