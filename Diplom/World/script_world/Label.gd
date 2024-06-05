extends Label

@onready var imp_test: Control = get_parent().get_parent()
@onready var wheel: RayCast3D = get_parent().get_node("int_objects/Car/wheels2/r_1")
@onready var car: RigidBody3D = get_parent().get_node("int_objects/Car")  # Получение доступа к твердому телу автомобиля.
@onready var text_s

func _ready():
	pass

func _process(delta):
	var FPS = Engine.get_frames_per_second()
	var fps_check = " FPS: " + str(FPS)
	var text = imp_test.season.get_item_id(imp_test.season.get_selected())
	var speed = round(car.linear_velocity.length()*3.6)
	var engine_speed = wheel.engine_speed
	var t = car.current_transmission
	var car = str(speed)
	if text == 0:
		text_s = "Зима"
	if text == 1:
		text_s = "Весна"
	if text == 2:
		text_s = "Лето"
	if text == 3:
		text_s = "Осень"
	set_text(text_s + fps_check + " " + car + " Км/ч")
	
	$arrow.rotation_degrees = (speed - 230) + speed / 2
	while engine_speed <= 7 :
		$arrow2.rotation_degrees = -240 + (engine_speed * 30)
		break
	$speed.set_text(car + " Км/ч")
	
	if t == 0:
		$t.texture = preload("res://images/N.png")
	elif t == 1:
		$t.texture = preload("res://images/1.png")
	elif t == 2:
		$t.texture = preload("res://images/2.png")
	elif t == 3:
		$t.texture = preload("res://images/3.png")
	elif t == 4:
		$t.texture = preload("res://images/4.png")
	elif t == 5:
		$t.texture = preload("res://images/5.png")
	elif t == 7:
		$t.texture = preload("res://images/R.png")
