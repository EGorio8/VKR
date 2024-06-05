extends RayCast3D  # Расширение функциональности текущего объекта до трехмерного луча.

@export var is_front_wheel: bool  # Флаг, определяющий, является ли колесо передним.
@onready var car: RigidBody3D = get_parent().get_parent()  # Получение доступа к твердому телу автомобиля.
@onready var previous_spring_length: float = 0.0  # Предыдущая длина пружины подвески.
@onready var collision_point

@onready var engine_speed = 1

@onready var t

func _ready():
	add_exception(car)  # Добавление исключения для предотвращения коллизий с автомобилем.

func _physics_process(delta):
	if is_colliding():
		collision_point = get_collision_point()  # Получение точки столкновения.
		suspension(delta, collision_point)  # Обработка подвески.
		acceleration(collision_point)  # Применение ускорения.
		apply_x_force(collision_point)  # Применение силы по оси X.
		apply_z_force(delta, collision_point)  # Применение силы по оси Z.
		gravity()

func apply_z_force(delta, collision_point):
	var dir: Vector3 = global_basis.z  # Направление по оси Z.
	var tire_world_vel: Vector3 = get_point_velocity(global_position)  
	var latereal_vel: float = dir.dot(tire_world_vel) 
	var grip = car.rear_tire_grip  # Сцепление задних колес.
	if is_front_wheel:
		grip = car.front_tire_grip  # Если колесо переднее, используется сцепление передних колес.
	var desired_vel_change: float = -latereal_vel * grip  # Желаемое изменение скорости.
	var z_force = desired_vel_change + delta  # Сила по оси Z.
	car.apply_force(dir * z_force, collision_point - car.global_position)  # Применение силы.

func get_point_velocity(point: Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)  # Получение скорости точки.
	
func apply_x_force(collision_point):
	var dir: Vector3 = global_basis.x  # Направление по оси X.
	var tire_world_vel: Vector3 = get_point_velocity(global_position)  # Скорость колеса в мировых координатах.
	var x_force = dir.dot(tire_world_vel) * car.mass / 10  # Сила по оси X.
	car.apply_force(-dir * x_force, collision_point - car.global_position)  # Применение силы.
	# Создание точки в мировых координатах для применения силы по оси X.
	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.x)

func acceleration(collision_point):
	var speed = round(car.linear_velocity.length()*3.6)
	var accel_dir = -global_basis.x  # Направление ускорения.
	t = 0
	var transmission_changed = false

	if Input.is_action_just_pressed("transmission_1"):
		t = 1
		transmission_changed = true
	elif Input.is_action_just_pressed("transmission_2"):
		t = 2
		transmission_changed = true
	elif Input.is_action_just_pressed("transmission_3"):
		t = 3
		transmission_changed = true
	elif Input.is_action_just_pressed("transmission_4"):
		t = 4
		transmission_changed = true
	elif Input.is_action_just_pressed("transmission_5"):
		t = 5
		transmission_changed = true
	#elif Input.is_action_just_pressed("transmission_6"):
		#t = 6
		#transmission_changed = true
	elif Input.is_action_just_pressed("transmission_R"):
		t = 7
		transmission_changed = true

	if transmission_changed:
		car.current_transmission = t

	if Input.is_action_pressed("accelerate"):
		engine_speed += 0.01
		if engine_speed < 7:
			if car.current_transmission == 1:  
				car.engine_power = 0.3 * engine_speed
			elif car.current_transmission == 2:  
				car.engine_power = 0.525 * engine_speed
			elif car.current_transmission == 3:
				while engine_speed<6:
					car.engine_power = 0.9 * engine_speed
					break
			elif car.current_transmission == 4:
				while engine_speed<5:
					car.engine_power = 1.25 * engine_speed
					break
			elif car.current_transmission == 5:
				while engine_speed<4.5:
					car.engine_power = 1.6 * engine_speed
					break
			#elif car.current_transmission == 6:  
				#car.engine_power = 0
			elif car.current_transmission == 7:
				car.engine_power = -0.3 * engine_speed
			else:
				car.engine_power = 0

	if not Input.is_action_pressed("accelerate"):
			if engine_speed > 1 :
				while engine_speed > 1:
					engine_speed -= 0.1
					break
			else:
				engine_speed = 1

	if Input.is_action_pressed("reverse"):
		if speed == 0:
			car.engine_power = 0
		elif speed > 5:
			car.engine_power = 2
		else:
			car.engine_power = 0

	var torque = car.accel_input * car.engine_power  # крутящий момент двигателя.
	var point = Vector3(collision_point.x, collision_point.y - car.wheel_radius, collision_point.z)
	car.apply_force(accel_dir * torque, point - car.global_position)  # Применение ускорения.

func suspension(delta, collision_point):
	var susp_dir = global_basis.y  # Направление подвески.
	var raycast_origin = global_position
	var raycast_dest = collision_point
	var distance = raycast_dest.distance_to(raycast_origin)  # Расстояние до точки столкновения.
	var spring_length = clamp(distance - car.wheel_radius, 0, car.suspension_rest_dist)  # Длина пружины.
	var spring_force = car.spring_strength * (car.suspension_rest_dist - spring_length)  # Сила пружины.
	var spring_velocity = (previous_spring_length - spring_length)/delta  # Скорость изменения длины пружины.
	var damper_force = car.spring_damper * spring_velocity 
	var suspension_force = basis.y * (spring_force + damper_force)  # Сила подвески.
	previous_spring_length = spring_length  # Обновление предыдущей длины пружины.
	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.z)
	car.apply_force(susp_dir * suspension_force, point - car.global_position)  # Применение силы подвески.
	
func gravity():
	var gravity = 0.5
	collision_point = get_collision_point()
	var surface_normal = get_collision_normal()  # Получаем нормаль поверхности, с которой происходит коллизия.
	var gravity_force = surface_normal * gravity * car.mass  # Рассчитываем силу тяжести, умножая ускорение на массу автомобиля.
	car.apply_force(gravity_force, collision_point - car.global_position)  # Применение силы тяжести.
