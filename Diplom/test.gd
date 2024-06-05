extends Control
@onready var car: RigidBody3D = get_parent().get_parent()
@onready var wheel: RayCast3D = get_parent().get_parent().get_node("wheels2/r_1")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = round(car.linear_velocity.length()*3.6)
	var engine_speed = wheel.engine_speed
	var car = str(speed)
	$arrow2.rotation_degrees = (speed - 230) + speed / 2
	while engine_speed <= 7 :
		$arrow.rotation_degrees = -240 + (engine_speed * 30)
		break
	$speed.set_text(car + " Км/ч")
	pass
