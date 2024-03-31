class_name Interface
extends Control


@export_node_path("LevelListPopup") var _level_list_popup_path: NodePath
@export_node_path("LevelCompletePopup") var _level_completed_popup_path: NodePath
@export_node_path("LevelFailedPopup") var _level_failed_popup_path: NodePath
@export_node_path("SettingsPopup") var _settings_popup_path: NodePath

@export_node_path("LevelHud") var _level_hud_path: NodePath
@export_node_path("MenuHud") var _menu_hud_path: NodePath

@onready var _level_list_popup: LevelListPopup = get_node(_level_list_popup_path)
@onready var _level_completed_popup: LevelCompletePopup = get_node(_level_completed_popup_path)
@onready var _level_failed_popup: LevelFailedPopup = get_node(_level_failed_popup_path)
@onready var _settings_popup: SettingsPopup = get_node(_settings_popup_path)

@onready var _level_hud: LevelHud = get_node(_level_hud_path)
@onready var _menu_hud: MenuHud = get_node(_menu_hud_path)


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	Events.level_completed.connect(_on_level_completed)
	Events.level_failed.connect(_on_level_failed)
	Events.home_return_request.connect(_on_home_return_request)
	Events.settings_show_request.connect(_on_settings_show_request)


func _on_level_started(_level_id: String) -> void:
	_level_list_popup.hide_popup()
	_level_completed_popup.hide_popup()
	_level_failed_popup.hide_popup()
	_settings_popup.hide_popup()
	_menu_hud.hide()
	
	_level_hud.show()


func _on_level_completed(_level_id: String, _stars: int) -> void:
	_level_hud.hide()
	
	_level_completed_popup.show_popup()


func _on_level_failed(_level_id: String) -> void:
	_level_hud.hide()
	
	_level_failed_popup.show_popup()


func _on_home_return_request() -> void:
	_level_completed_popup.hide_popup()
	_level_failed_popup.hide_popup()
	_settings_popup.hide_popup()
	_level_hud.hide()
	
	_level_list_popup.show_popup()
	_menu_hud.show()
	
	Events.home_returned.emit()


func _on_settings_show_request() -> void:
	_settings_popup.show_popup()
