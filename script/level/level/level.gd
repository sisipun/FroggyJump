class_name Level
extends Area2D


@export_node_path("CollisionShape2D") var _spawn_area_path: NodePath
@export_node_path("Node2D") var _platforms_path: NodePath
@export_node_path("Node2D") var _jumpers_path: NodePath
@export var _jumper_scene: PackedScene
@export var _platform_scene: PackedScene

@onready var _spawn_area: CollisionShape2D = get_node(_spawn_area_path)
@onready var _platforms: Node2D = get_node(_platforms_path)
@onready var _jumpers: Node2D = get_node(_jumpers_path)

@export var _level_id: String
@export var _platform_margin: Vector2 

var _platform_map: Array[Array] = []
var _level_model: LevelModel
var _selected_possible_moves: Array[Vector2i] = []


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	clear()
	start()


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func clear() -> void:
	if _level_model == null:
		return
	
	_level_model.selected.disconnect(_on_selected)
	_level_model.unselected.disconnect(_on_unselected)
	_level_model.jumper_moved.disconnect(_on_jumper_moved)
	_level_model.jumper_hitted.disconnect(_on_jumper_hitted)
	_level_model.jumper_dead.disconnect(_on_jumper_dead)
	_level_model.finished.disconnect(_on_level_finished)
	_level_model = null
	
	for line in _platform_map:
		for platform in line:
			if platform != null:
				_remove_jumper(platform.coordinates.x, platform.coordinates.y)
				platform.clicked.disconnect(_on_platform_clicked)
				platform.queue_free()
	_platform_map.clear()


func start() -> void:
	_level_model = Levels.get_model_by_id(_level_id)
	_level_model.selected.connect(_on_selected)
	_level_model.unselected.connect(_on_unselected)
	_level_model.jumper_moved.connect(_on_jumper_moved)
	_level_model.jumper_hitted.connect(_on_jumper_hitted)
	_level_model.jumper_dead.connect(_on_jumper_dead)
	_level_model.finished.connect(_on_level_finished)
	
	var spawn_area_size: Vector2 = _spawn_area.shape.b - _spawn_area.shape.a
	var level_size: Vector2 = Vector2(_level_model.get_width(), _level_model.get_height())
	var platform_size: Vector2 = (spawn_area_size - _platform_margin * (level_size + Vector2(1, 1))) / level_size
	var jumper_size: Vector2 = platform_size / 2.0
	
	for x in range(_level_model.get_width()):
		_platform_map.append([])
		for y in range(_level_model.get_height()):
			if not _level_model.has_platform(x, y):
				_platform_map[x].append(null)
				continue
			
			var platform_model: PlatformModel = _level_model.get_platform(x, y)
			var platform_resource: PlatformResource = Platforms.get_resource_by_type(platform_model.get_type())
			var spawn_position = _spawn_area.shape.a + _platform_margin + (platform_size / 2) + Vector2(x, y) * (_platform_margin + platform_size)
			var platform: Platform = _platform_scene.instantiate()
			_platforms.add_child(platform)
			platform.init(
				platform_model.get_coordinates(), 
				spawn_position, 
				platform_size, 
				platform_resource.sprite_frames
			)
			platform.clicked.connect(_on_platform_clicked)
			
			if platform_model.has_jumper():
				var jumper_model: JumperModel = platform_model.get_jumper()
				var jumper_resource: JumperResource = Jumpers.get_resource_by_type(jumper_model.get_type())
				var jumper: Jumper = _jumper_scene.instantiate()
				_jumpers.add_child(jumper)
				jumper.init(
					jumper_size, 
					jumper_model.get_jump_distance(), 
					jumper_model.get_health(), 
					jumper_resource.sprite_frames
				)
				platform.jumper = jumper
			
			_platform_map[x].append(platform)
	Events.emit_signal("level_started", _level_id)


func _on_platform_clicked(x: int, y: int) -> void:
	_level_model.select(x, y)


func _on_selected(x: int, y: int) -> void:
	var selected: Platform = _platform_map[x][y]
	selected.show_as_current()
	
	_selected_possible_moves = _level_model.get_possible_moves(x, y)
	for move in _selected_possible_moves:
		_platform_map[move.x][move.y].show_as_possible_move()


func _on_unselected(x: int, y: int) -> void:
	for move in _selected_possible_moves:
		_platform_map[move.x][move.y].show_as_default()
	_selected_possible_moves.clear()
	
	var unselected: Platform = _platform_map[x][y]
	unselected.show_as_default()


func _on_jumper_moved(x_from: int, y_from: int, x_to: int, y_to: int) -> void:
	var platform_from: Platform = _platform_map[x_from][y_from]
	var platform_to: Platform = _platform_map[x_to][y_to]
	var jumper: Jumper = platform_from.jumper
	platform_from.remove_jumper()
	platform_to.jumper = jumper


func _on_jumper_hitted(current_health: int, x: int, y: int) -> void:
	var platform: Platform = _platform_map[x][y]
	var jumper: Jumper = platform.jumper
	jumper.health = current_health


func _on_jumper_dead(x: int, y: int) -> void:
	_remove_jumper(x, y)


func _on_level_finished(won: bool) -> void:
	if won:
		Events.emit_signal("level_completed", _level_id)
	else:
		clear()
		start()


func _remove_jumper(x: int, y: int) -> void:
	var platform: Platform = _platform_map[x][y]
	if platform.has_jumper():
		var jumper: Jumper = platform.jumper
		platform.remove_jumper()
		jumper.queue_free()
