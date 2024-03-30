class_name LevelPreview
extends NinePatchRect


const DRAG_TRESHOLD: int = 50

@export_node_path("Label") var _name_label_path: NodePath
@export_node_path("LevelStars") var _level_stars_path: NodePath

@export var level_id: String
@export var background_available: Texture
@export var background_unavailable: Texture

@onready var _name_label: Label = get_node(_name_label_path)
@onready var _stars: LevelStars = get_node(_level_stars_path)

var available: bool:
	set(value):
		available = value
		texture = background_available if available else background_unavailable
var drag: int


func _ready() -> void:
	_name_label.text = level_id
	_stars.value = Levels.get_stars(level_id)
	available = Levels.is_available(level_id)
	
	Events.level_completed.connect(_on_level_completed)


func _gui_input(event: InputEvent) -> void:
	if not available:
		return
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			drag = 0
		elif abs(drag) < DRAG_TRESHOLD:
			drag = 0
			Events.level_start_request.emit(level_id)
		
	
	if event is InputEventScreenDrag:
		drag += event.relative.y


func _on_level_completed(_level_id: String, _stars_count: int) -> void:
	if level_id == _level_id:
		_stars.value = _stars_count
	if not available:
		available = Levels.is_available(level_id)
