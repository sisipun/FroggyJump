class_name LazyScrollContainer
extends DragScrollContainer


@export_node_path("Control") var _scenes_node_path: NodePath

@export var _packed_scenes: Array[PackedScene]
@export var _lazy_step: int = 1

@onready var _scenes: Control = get_node(_scenes_node_path)

var _loaded_scenes: Dictionary
var _current_scene_index: int:
	set(value):
		_current_scene_index = value
		_lazy_load_scenes(_current_scene_index, _lazy_step)


func _ready() -> void:
	_loaded_scenes = {}
	_current_scene_index = 0
	
	scroll_ended.connect(_on_scroll_ended)


func _on_scroll_ended() -> void:
	_select_current_scene()


func _select_current_scene() -> void:
	var current_scene: Control = _loaded_scenes[_current_scene_index]
	while (
		scroll_vertical + size.y > current_scene.position.y + current_scene.size.y
		and _packed_scenes.size() > _current_scene_index + 1
	):
		_current_scene_index += 1
		current_scene = _loaded_scenes[_current_scene_index]


func _lazy_load_scenes(current_index: int, step: int) -> void:
	for i in range(-step, step + 1):
		_load_scene(current_index + i)


func _load_scene(index: int) -> bool:
	if index < 0 or _packed_scenes.size() <= index or _loaded_scenes.has(index):
		return false
	
	
	var loaded_scene: Control = _packed_scenes[index].instantiate()
	_loaded_scenes[index] = loaded_scene
	_scenes.add_child(loaded_scene)
	return true
