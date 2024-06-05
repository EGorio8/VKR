extends Node3D

@onready var player: CharacterBody3D = get_node("int_objects/Player")
@onready var id_season: Control = get_parent()
@onready var menu = get_parent().get_parent().get_node("Menu")
@onready var world = get_parent().get_parent().get_node("Menu/World")

func _process(delta):
	if Input.is_action_pressed("menu"):
		player.mouse_sense = 0
		menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
