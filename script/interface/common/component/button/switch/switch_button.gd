class_name SwitchButton
extends CommonButton


@export var true_normal: Texture2D
@export var false_normal: Texture2D

@export var state: bool = true :
	set(value):
		state = value
		if state:
			texture_normal = true_normal
		else:
			texture_normal = false_normal


func _ready() -> void:
	super()
