extends RayCast3D

@onready var coll
@onready var camera
var firstInteraction = true

@onready var player: CharacterBody3D = get_parent().get_parent()
@onready var player_col: CollisionShape3D = get_parent().get_parent().get_node("CollisionShape3D")
@onready var car: RigidBody3D = get_parent().get_parent().get_parent().get_node("Car")

func _process(delta):
	coll = self.get_collider()
	camera = get_parent().get_node("Camera3D")
	if self.is_colliding():
		if coll.is_in_group("interactable"):
			$InteractableUI.show()
			if Input.is_action_just_pressed("interact"):
				if firstInteraction:
					player.position =  car.position + Vector3(0,0,10)
					firstInteraction = false
				else:
					player.position =  car.position + Vector3(0,2,0)
					firstInteraction = true
				if camera.is_current():
					camera.set_current(false)
				else:
					camera.set_current(true)
	else:
		$InteractableUI.hide()
