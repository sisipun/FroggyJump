class_name LevelStars
extends HBoxContainer


@export_node_path("NinePatchRect") var _star_1_path: NodePath
@export_node_path("NinePatchRect") var _star_2_path: NodePath
@export_node_path("NinePatchRect") var _star_3_path: NodePath

@onready var _star_1: NinePatchRect = get_node(_star_1_path)
@onready var _star_2: NinePatchRect = get_node(_star_2_path)
@onready var _star_3: NinePatchRect = get_node(_star_3_path)

var value: int:
	set(new_value):
		value = new_value
		_set_star_state(value, 1, _star_1)
		_set_star_state(value, 2, _star_2)
		_set_star_state(value, 3, _star_3)


func _set_star_state(stars: int, star_number: int, star: NinePatchRect) -> void:
	if stars >= star_number:
		star.modulate.a = 1
	else:
		star.modulate.a = 0
