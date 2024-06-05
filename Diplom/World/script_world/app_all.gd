extends Node3D

@onready var player: CharacterBody3D = get_node("Menu/World/int_objects/Player")
@onready var rain = get_node("Menu/World/int_objects/Car/Rain")
@onready var snow = get_node("Menu/World/int_objects/Car/Snow")
@onready var menu = get_node("Menu")
@onready var world = get_node("Menu/World")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.mouse_sense = 0
	rain.hide()
	snow.hide()
	menu.show()
	world.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
