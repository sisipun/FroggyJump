class_name LazyScrollContainer
extends DragScrollContainer


@export_node_path("Control") var _scenes_node_path: NodePath

@export var _packed_scenes: Array[PackedScene]
@export var _lazy_step: int = 1

@onready var _scenes: Control = get_node(_scenes_node_path)

var _loaded_scenes: Dictionary
var _current_scene_index: int:
	set(value):
		var previous_scene_index = _current_scene_index
		_current_scene_index = value
		_lazy_load_scenes(previous_scene_index, _current_scene_index, _lazy_step)


func _ready() -> void:
	_loaded_scenes = {}
	_current_scene_index = 0
	
	vertical_scroll.connect(_on_vertical_scroll)


func _on_vertical_scroll(old_value: int, new_value: int) -> void:
	var scroll_direction: int = new_value - old_value
	while _next_scene_appeared(_current_scene_index, scroll_direction):
		var next_scene_index = _current_scene_index + (1 if scroll_direction > 0 else -1)
		if _is_scene_available(next_scene_index):
			_current_scene_index = next_scene_index
		else:
			set_scroll_vertical(old_value)


func _is_scene_available(_index: int) -> bool:
	return _loaded_scenes[_index].is_available()


func _next_scene_appeared(current_scene_index: int, direction: int) -> bool:
	var current_scene: Control = _loaded_scenes[current_scene_index]
	if (
		direction > 0
		and current_scene.position.y + current_scene.size.y < scroll_vertical + size.y 
		and _current_scene_index + 1 < _packed_scenes.size()
	):
		return true
	elif (
		direction < 0
		and current_scene.position.y >= scroll_vertical + size.y
		and _current_scene_index > 0
	):
		return true
	
	return false


func _lazy_load_scenes(previous_index: int, current_index: int, step: int) -> void:
	var drection: int = current_index - previous_index
	var load_range = range(current_index - step, current_index + step + 1)
	var free_ragne = range(0, current_index - step) + range(current_index + step + 1, _packed_scenes.size())
	if drection < 0:
		load_range.reverse()
		free_ragne.reverse()
	
	for i in load_range:
		var scene: Control = _load_scene(i)
		if scene and drection < 0:
			_scenes.move_child(scene, 0)
			scroll_vertical +=int(scene.custom_minimum_size.y)
	
	for i in free_ragne:
		var scene: Control = _free_scene(i)
		if scene and drection >= 0:
			scroll_vertical -= int(scene.custom_minimum_size.y)


func _load_scene(index: int) -> Control:
	if index < 0 or index >= _packed_scenes.size() or _loaded_scenes.has(index):
		return null
	
	
	var loaded_scene: Control = _packed_scenes[index].instantiate()
	_loaded_scenes[index] = loaded_scene
	_scenes.add_child(loaded_scene)
	return loaded_scene


func _free_scene(index: int) -> Control:
	if index < 0 or index >= _packed_scenes.size() or not _loaded_scenes.has(index):
		return null
	
	var scene: Control = _loaded_scenes[index]
	scene.queue_free()
	_loaded_scenes.erase(index)
	return scene
