extends RigidBody3D  # Расширение функциональности текущего объекта до твердого тела с трехмерной физикой.

@export var suspension_rest_dist: float = 0.5  # Расстояние, на которое может опуститься подвеска автомобиля.
@export var spring_strength: float = 10  # Сила пружины в подвеске.
@export var spring_damper: float = 1  # Сила демпфирования подвески.
@export var wheel_radius: float = 0.33  # Радиус колеса.
@export var debug: bool = false  # Флаг отладочного режима.
@export var engine_power: float  # Мощность двигателя.
@export var steering_angle: float  # Угол поворота руля.
@export var front_tire_grip: float = 2.0  # Сцепление передних колес.
@export var rear_tire_grip: float = 2.0  # Сцепление задних колес.
@onready var accel_input  # Переменная для ввода ускорения.
@onready var steering_input  # Переменная для ввода угла поворота руля.
@onready var steering_rotation
@onready var fl_wheel = $wheels2/l_1  # Левое переднее колесо.
@onready var fr_wheel = $wheels2/r_1  # Правое переднее колесо.
@onready var rudder = $rudder
@onready var angle
@onready var new_rotation
@onready var new_Camera = $Camera3D
@onready var new_Camera2 = $Camera3D2

@onready var current_transmission

func _process(delta):
	if Input.get_axis("turn_right", "turn_left"):
		while steering_angle != 30:
			steering_angle +=1
			break
	accel_input = Input.get_axis("accelerate", "reverse")  # Получение ввода для ускорения/торможения.
	steering_input = Input.get_axis("turn_right", "turn_left")  # Получение ввода для поворота руля.
	steering_rotation = steering_input * steering_angle  # Вычисление угла поворота руля.
	
	if not Input.get_axis("turn_right", "turn_left"):
		steering_angle = 0

	if steering_rotation != 0:
		angle = clamp(fl_wheel.rotation.y + steering_rotation, -steering_angle, steering_angle)
		new_rotation = angle * delta  # Вычисление нового угла поворота.

		fl_wheel.rotation.y = lerp(fl_wheel.rotation.y, new_rotation, 0.3)  # Плавное изменение угла поворота колес.
		fr_wheel.rotation.y = lerp(fr_wheel.rotation.y, new_rotation, 0.3)
		rudder.rotation.x = lerp(fr_wheel.rotation.y, new_rotation * 60, 0.3)
	else:
		fl_wheel.rotation.y = lerp(fl_wheel.rotation.y, 0.0, 0.3)  # Возвращение колес в исходное положение.
		fr_wheel.rotation.y = lerp(fr_wheel.rotation.y, 0.0, 0.3)
		rudder.rotation.x = lerp(fr_wheel.rotation.y, 0.0, 0.3)

	if Input.is_action_pressed("2"):
		new_Camera.set_current(false)
		new_Camera2.set_current(true)

	if Input.is_action_pressed("1"):
		new_Camera.set_current(true)
		new_Camera2.set_current(false)


