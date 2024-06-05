extends Camera3D

@onready var cam_1 = get_parent().get_node("Camera3D3")
@onready var cam_2 = get_parent().get_node("Camera3D3")
@onready var car = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_1.global_transform.origin = car.global_transform.origin
	cam_1.global_transform.basis = car.global_transform.basis
	cam_1.rotate_y(deg_to_rad(90))
	cam_1.translate(Vector3(-1, 0.8, 0.3))
	cam_2.global_transform.origin = car.global_transform.origin
	cam_2.global_transform.basis = car.global_transform.basis
	cam_2.rotate_y(deg_to_rad(90))
	cam_2.translate(Vector3(-1, 0.8, 0.3))
