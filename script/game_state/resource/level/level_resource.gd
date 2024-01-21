class_name LevelResource
extends Resource


@export var id: String
@export var width: int
@export var height: int
@export var win_condition: int
@export var _two_star_condition: int
@export var _three_star_condition: int
@export var default_cell: LevelCellResource
@export var custom_cells: Array[LevelCellCustomResource]
@export var required_levels: Array[String]


func get_two_star_condition() -> int:
	return min(_two_star_condition, win_condition)


func get_three_star_condition() -> int:
	return min(_three_star_condition, get_two_star_condition())
