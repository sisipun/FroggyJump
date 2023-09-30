class_name Level
extends Area2D


@export_node_path("CollisionShape2D") var _spawn_area_path: NodePath
@export var _jumper_scene: PackedScene
@export var _platform_scene: PackedScene

@export var _level_size: Vector2i
@export var _platform_margin: Vector2 

@onready var _spawn_area: CollisionShape2D = get_node(_spawn_area_path)


func _ready() -> void:
	print(Vector2(1, 2) / Vector2(2, 3))
	var spawn_area_size: Vector2 = _spawn_area.shape.b - _spawn_area.shape.a
	var level_size: Vector2 = Vector2(_level_size.x, _level_size.y)
	var platform_size: Vector2 = (spawn_area_size - _platform_margin * (level_size + Vector2(1, 1))) / level_size
	
	for i in range(_level_size.x):
		for j in range(_level_size.y):
			var platform: Platform = _platform_scene.instantiate()
			add_child(platform)
			platform.init(
				_spawn_area.shape.a + _platform_margin + (platform_size / 2) + Vector2(i, j) * (_platform_margin + platform_size), 
				platform_size
			)
