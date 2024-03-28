class_name Interface
extends Control


@export_node_path("LevelListPopup") var _level_list_popup_path: NodePath
@export_node_path("LevelCompletePopup") var _level_complete_popup_path: NodePath
@export_node_path("MenuPopup") var _menu_popup_path: NodePath

@export_node_path("CommonButton") var _menu_button_path: NodePath

@export_node_path("Label") var _level_goal_label_path: NodePath

@onready var _level_list_popup: LevelListPopup = get_node(_level_list_popup_path)
@onready var _level_complete_popup: LevelCompletePopup = get_node(_level_complete_popup_path)
@onready var _menu_popup: MenuPopup = get_node(_menu_popup_path)

@onready var _menu_button: CommonButton = get_node(_menu_button_path)

@onready var _level_goal_label: Label = get_node(_level_goal_label_path)


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.level_goal_changed.connect(_on_level_goal_changed)
	Events.level_completed.connect(_on_level_completed)
	Events.home_return_request.connect(_on_home_return_request)
	
	_menu_button.pressed.connect(_on_menu_button_pressed)


func _on_level_started(_level_id: String) -> void:
	_level_list_popup.hide()
	_level_complete_popup.hide()
	_menu_popup.hide()
	_level_goal_label.show()


func _on_level_goal_changed(jumpers_count: int, jumpers_goal: int, stars_count: int) -> void:
	_level_goal_label.text = "%d - %d/%d" % [stars_count, jumpers_count, jumpers_goal]


func _on_level_completed(_level_id: String, _stars: int) -> void:
	_level_goal_label.hide()
	_menu_popup.hide()
	_level_complete_popup.show()


func _on_home_return_request() -> void:
	_level_complete_popup.hide()
	_menu_popup.hide()
	_level_list_popup.show()
	Events.home_returned.emit()


func _on_menu_button_pressed() -> void:
	_menu_popup.show()
