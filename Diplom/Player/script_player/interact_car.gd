extends MeshInstance3D

@onready var camera

func _interact():
	camera = $Camera3D
	if Input.is_action_pressed("interact"):
		camera.hide()
	else:
		camera.show()
