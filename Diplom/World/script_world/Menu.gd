extends Control

@onready var player: CharacterBody3D = get_node("World/int_objects/Player")
@onready var season = $Panel/OptionButton
@onready var road_condition = $Panel/OptionButton2
@onready var time_of_day = $Panel/OptionButton3
@onready var weather_conditions = $Panel/OptionButton4
@onready var length = $Panel/LineEdit

@onready var car: RigidBody3D = get_node("World/int_objects/Car")

@onready var rain = get_parent().get_node("Menu/World/int_objects/Car/Rain")
@onready var snow = get_parent().get_node("Menu/World/int_objects/Car/Snow")
@onready var mat1= preload("res://Models/tries_textures/mat1.tres")
@onready var mat2= preload("res://Models/tries_textures/mat2.tres")
@onready var mat3= preload("res://Models/tries_textures/mat3.tres")
@onready var new_mesh_instance
@onready var light = $World/DirectionalLight3D
@onready var menu = get_parent().get_node("Menu")
@onready var world = get_parent().get_node("Menu/World")
@onready var r_particles = get_parent().get_node("Menu/World/int_objects/Car/Rain/GPUParticles3D")
@onready var s_particles = get_parent().get_node("Menu/World/int_objects/Car/Snow/GPUParticles3D")
@onready var fog = preload("res://World/world.tres")
@onready var base_mesh_instance
@onready var base_mesh_instance2
@onready var base_mesh_instance3
@onready var num
@onready var if_id
@onready var id_season
@onready var id_time_of_day
@onready var id_weather_conditions
@onready var if_id_road_condition
@onready var environment

func _ready():
	_on_option_button_pressed()
	_on_option_button_2_pressed()
	_on_option_button_3_pressed()
	_on_option_button_4_pressed()
	
	pass

func _on_option_button_pressed():
	season.clear()
	season.add_item("Зима")
	season.add_item("Весна")
	season.add_item("Лето")
	season.add_item("Осень")
	pass # Replace with function body.

func _on_option_button_2_pressed():
	if_id = season.get_item_id(season.get_selected())
	if if_id == 0:
		road_condition.clear()
		road_condition.add_item("Мокрый асфальт",1)
		road_condition.add_item("Заснеженный асфальт",0)
		road_condition.add_item("Гололёдный асфальт",2)
		road_condition.add_item("Бездорожье",4)
	elif if_id == 1:
		road_condition.clear()
		road_condition.add_item("Сухой асфальт",3)
		road_condition.add_item("Мокрый асфальт",1)
		road_condition.add_item("Бездорожье",4)
	elif if_id == 2:
		road_condition.clear()
		road_condition.add_item("Сухой асфальт",3)
		road_condition.add_item("Мокрый асфальт",1)
		road_condition.add_item("Бездорожье",4)
	elif if_id == 3:
		road_condition.clear()
		road_condition.add_item("Сухой асфальт",3)
		road_condition.add_item("Мокрый асфальт",1)
		road_condition.add_item("Гололёдный асфальт",2)
		road_condition.add_item("Бездорожье",4)
	pass # Replace with function body.

func _on_option_button_3_pressed():
	time_of_day.clear()
	time_of_day.add_item("Утро", 0)
	time_of_day.add_item("День", 1)
	time_of_day.add_item("Вечер", 2)
	time_of_day.add_item("Ночь", 3)
	pass # Replace with function body.

func _on_option_button_4_pressed():
	if_id = season.get_item_id(season.get_selected())
	if if_id == 0:
		weather_conditions.clear()
		weather_conditions.add_item("Ясно", 0)
		weather_conditions.add_item("Слабый снегопад", 5)
		weather_conditions.add_item("Средний снегопад", 6)
		weather_conditions.add_item("Сильный снегопад", 7)
	if if_id == 1:
		weather_conditions.clear()
		weather_conditions.add_item("Ясно", 0)
		weather_conditions.add_item("Слабый дождь", 1)
		weather_conditions.add_item("Средний дождь", 2)
		weather_conditions.add_item("Сильный дождь", 3)
		weather_conditions.add_item("Туман", 4)
	if if_id == 2:
		weather_conditions.clear()
		weather_conditions.add_item("Ясно", 0)
		weather_conditions.add_item("Слабый дождь", 1)
		weather_conditions.add_item("Средний дождь", 2)
		weather_conditions.add_item("Сильный дождь", 3)
		weather_conditions.add_item("Туман", 4)
	if if_id == 3:
		weather_conditions.clear()
		weather_conditions.add_item("Ясно", 0)
		weather_conditions.add_item("Слабый дождь", 1)
		weather_conditions.add_item("Средний дождь", 2)
		weather_conditions.add_item("Сильный дождь", 3)
		weather_conditions.add_item("Туман", 4)
		weather_conditions.add_item("Слабый снегопад", 5)
		weather_conditions.add_item("Средний снегопад", 6)
	pass # Replace with function body.

func _on_play_pressed():
	PhysicsServer3D.body_set_state(
	car.get_rid(),
	PhysicsServer3D.BODY_STATE_TRANSFORM,
	Transform3D.IDENTITY.translated(Vector3(-65, 3.1, 5)))
	player.position = Vector3(-65, 3, 0)
	
	id_season = season.get_item_id(season.get_selected())
	id_time_of_day = time_of_day.get_item_id(time_of_day.get_selected())
	id_weather_conditions = weather_conditions.get_item_id(weather_conditions.get_selected())
	if_id_road_condition = road_condition.get_item_id(road_condition.get_selected())
	player.mouse_sense = 0.1
	menu.hide()
	world.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for child in $World/Дорога.get_children():
		if child.name.find("new_mesh_instance") != -1:
			$World/Дорога.remove_child(child)
			child.queue_free()
	num = int($Panel/LineEdit.text)
	if num == null or num<8:
		num = 8
	base_mesh_instance = $World/Дорога.get_node("Плоскость")
	base_mesh_instance2 = $World/Дорога.get_node("Плоскость2")
	base_mesh_instance3 = $World/Дорога.get_node("Плоскость3")
	var i = 0
	var j = 0
	if id_season == 0 and if_id_road_condition == 0:
		mat1.albedo_texture = preload("res://Models/textures/JPG/winter_snowy.jpeg")
		base_mesh_instance.set_surface_override_material(0, mat1)
		mat2.albedo_texture = preload("res://Models/textures/JPG/winter_snowy_г.jpeg")
		base_mesh_instance2.set_surface_override_material(0, mat2)
		car.front_tire_grip = 1
		car.rear_tire_grip = 1
	if id_season == 0 and if_id_road_condition == 1:
		mat1.albedo_texture = preload("res://Models/textures/JPG/winter_wet.jpeg")
		base_mesh_instance.set_surface_override_material(0, mat1)
		mat2.albedo_texture = preload("res://Models/textures/JPG/winter_wet_г.jpeg")
		base_mesh_instance2.set_surface_override_material(0, mat2)
		car.front_tire_grip = 1.5
		car.rear_tire_grip = 1.5
	if id_season == 0 and if_id_road_condition == 2:
		mat1.albedo_texture = preload("res://Models/textures/JPG/winter_wet.jpeg")
		base_mesh_instance.set_surface_override_material(0, mat1)
		mat2.albedo_texture = preload("res://Models/textures/JPG/winter_wet_г.jpeg")
		base_mesh_instance2.set_surface_override_material(0, mat2)
		car.front_tire_grip = 0.5
		car.rear_tire_grip = 0.5
	if (id_season == 1 or id_season == 2 or id_season == 3) and if_id_road_condition == 3:
		mat1.albedo_texture = preload("res://Models/textures/JPG/summer_dry.jpeg")
		base_mesh_instance.set_surface_override_material(0, mat1)
		mat2.albedo_texture = preload("res://Models/textures/JPG/summer_dry_г.jpeg")
		base_mesh_instance2.set_surface_override_material(0, mat2)
		car.front_tire_grip = 2
		car.rear_tire_grip = 2
	if (id_season == 1 or id_season == 2 or id_season == 3) and if_id_road_condition == 1:
		mat1.albedo_texture = preload("res://Models/textures/JPG/summer_wet.jpeg")
		base_mesh_instance.set_surface_override_material(0, mat1)
		mat2.albedo_texture = preload("res://Models/textures/JPG/summer_wet_г.jpeg")
		base_mesh_instance2.set_surface_override_material(0, mat2)
		car.front_tire_grip = 1.5
		car.rear_tire_grip = 1.5
	if (id_season == 1 or id_season == 2 or id_season == 3) and if_id_road_condition == 2:
		mat1.albedo_texture = preload("res://Models/textures/JPG/summer_wet.jpeg")
		base_mesh_instance.set_surface_override_material(0, mat1)
		mat2.albedo_texture = preload("res://Models/textures/JPG/summer_wet_г.jpeg")
		base_mesh_instance2.set_surface_override_material(0, mat2)
		car.front_tire_grip = 0.5
		car.rear_tire_grip = 0.5
	if (id_season == 1 or id_season == 2 or id_season == 3) and if_id_road_condition == 4:
		mat3.albedo_texture = preload("res://Models/textures/JPG/Grunt_2.jpg")
		base_mesh_instance3.set_surface_override_material(0, mat3)
		car.front_tire_grip = 0.5
		car.rear_tire_grip = 0.5
	if (id_season == 0) and if_id_road_condition == 4:
		mat3.albedo_texture = preload("res://Models/textures/JPG/Grunt_winter.jpg")
		base_mesh_instance3.set_surface_override_material(0, mat3)
		car.front_tire_grip = 0.5
		car.rear_tire_grip = 0.5

	if if_id_road_condition!=4:
		base_mesh_instance.position = Vector3(0, 0, 0)
		base_mesh_instance2.position = Vector3(0, -100, 0)
		var num1 = num - 1
		var num2 = num1 - 4
		while i<=1:
			i = i+1
			new_mesh_instance = base_mesh_instance.duplicate()  # Копируем существующий узел "Плоскость"
			new_mesh_instance.position = Vector3(i * 200, 0, 0)  # Устанавливаем x координату
			new_mesh_instance.name = "new_mesh_instance1" + str(i)  # Устанавливаем уникальное имя для нового узла
			$World/Дорога.add_child(new_mesh_instance)
			i = i+1
			new_mesh_instance = base_mesh_instance2.duplicate()  # Копируем существующий узел "Плоскость"
			new_mesh_instance.position = Vector3(i * 200, 0, 0)  # Устанавливаем x координату
			new_mesh_instance.name = "new_mesh_instance1" + str(i)  # Устанавливаем уникальное имя для нового узла
			$World/Дорога.add_child(new_mesh_instance)
		i = 2
		while j<=((num2-3)/2)+1:
			j = j+1
			if j<=(num2-3)/2:
				new_mesh_instance = base_mesh_instance.duplicate()  # Копируем существующий узел "Плоскость"
				new_mesh_instance.position = Vector3(i * 200, 0, -(j * 200))  # Устанавливаем x координату
				new_mesh_instance.name = "new_mesh_instance2" + str(j)  # Устанавливаем уникальное имя для нового узла
				$World/Дорога.add_child(new_mesh_instance)
				new_mesh_instance.rotation.y = deg_to_rad(90)
			if j==((num2-3)/2)+1:
				new_mesh_instance = base_mesh_instance2.duplicate()  # Копируем существующий узел "Плоскость"
				new_mesh_instance.position = Vector3(i * 200, 0, -(j * 200))  # Устанавливаем x координату
				new_mesh_instance.name = "new_mesh_instance2" + str(j)  # Устанавливаем уникальное имя для нового узла
				$World/Дорога.add_child(new_mesh_instance)
				new_mesh_instance.rotation.y = deg_to_rad(-90)
		i = 2
		j = ((num2-3)/2)+1
		while i>=-1:
			i = i-1
			if i>-1:
				new_mesh_instance = base_mesh_instance.duplicate()  # Копируем существующий узел "Плоскость"
				new_mesh_instance.position = Vector3(i * 200, 0, -(j * 200))  # Устанавливаем x координату
				new_mesh_instance.name = "new_mesh_instance3" + str(i)  # Устанавливаем уникальное имя для нового узла
				$World/Дорога.add_child(new_mesh_instance)
			if i==-1:
				new_mesh_instance = base_mesh_instance2.duplicate()  # Копируем существующий узел "Плоскость"
				new_mesh_instance.position = Vector3(i * 200, 0, -(j * 200))  # Устанавливаем x координату
				new_mesh_instance.name = "new_mesh_instance3" + str(i)  # Устанавливаем уникальное имя для нового узла
				$World/Дорога.add_child(new_mesh_instance)
				new_mesh_instance.rotation.y = deg_to_rad(0)
		i = -1
		while j>=0:
			j = j-1
			if j>0:
				new_mesh_instance = base_mesh_instance.duplicate()  # Копируем существующий узел "Плоскость"
				new_mesh_instance.position = Vector3(i * 200, 0, -(j * 200))  # Устанавливаем x координату
				new_mesh_instance.name = "new_mesh_instance4" + str(j)  # Устанавливаем уникальное имя для нового узла
				$World/Дорога.add_child(new_mesh_instance)
				new_mesh_instance.rotation.y = deg_to_rad(90)
			if j==0:
				new_mesh_instance = base_mesh_instance2.duplicate()  # Копируем существующий узел "Плоскость"
				new_mesh_instance.position = Vector3(i * 200, 0, -(j * 200))  # Устанавливаем x координату
				new_mesh_instance.name = "new_mesh_instance4" + str(j)  # Устанавливаем уникальное имя для нового узла
				$World/Дорога.add_child(new_mesh_instance)
				new_mesh_instance.rotation.y = deg_to_rad(90)
	else:
		base_mesh_instance.position = Vector3(0, -90, 0)
		base_mesh_instance2.position = Vector3(0, -100, 0)
		new_mesh_instance = base_mesh_instance3.duplicate()
		new_mesh_instance.position = Vector3(0, -20, 0)
		new_mesh_instance.name = "new_mesh_instance"
		$World/Дорога.add_child(new_mesh_instance)
			

	environment = fog as Environment
	environment.fog_enabled = false
	environment.background_mode = Environment.BG_SKY
	light.light_energy = 0.1

	if id_time_of_day == 0:
		environment.background_energy_multiplier = 0.21
		environment.ambient_light_energy = 0.4
		environment.sky_rotation.y = 0
		light.rotation.y = -66
	if id_time_of_day == 1:
		environment.background_energy_multiplier = 0.6
		environment.ambient_light_energy = 2
		environment.sky_rotation.y = 45
		light.rotation.y = 64
	if id_time_of_day == 2:
		environment.background_energy_multiplier = 0.21
		environment.ambient_light_energy = 0.3
		environment.sky_rotation.y = 135
		light.rotation.y = 111
	if id_time_of_day == 3:
		environment.background_energy_multiplier = 0.02
		environment.ambient_light_energy = 0.01
		environment.sky_rotation.y = 180
		light.light_energy = 0

	# ясно
	if id_weather_conditions == 0:
		rain.hide()
		snow.hide()
	# слабый дождь
	if id_weather_conditions == 1:
		rain.show()
		snow.hide()
		r_particles.speed_scale = 20
		r_particles.amount = 9000
	# средний дождь
	if id_weather_conditions == 2:
		rain.show()
		snow.hide()
		r_particles.speed_scale = 21
		r_particles.amount = 15500
		light.light_energy = 0
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color(0.5, 0.58, 0.68)
	# сильный дождь
	if id_weather_conditions == 3:
		rain.show()
		snow.hide()
		r_particles.speed_scale = 22
		r_particles.amount = 100000
		light.light_energy = 0
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color(0.5, 0.58, 0.68)
	# туман
	if id_weather_conditions == 4:
		rain.hide()
		snow.hide()
		environment.fog_enabled = true
		light.light_energy = 0
		if id_time_of_day == 0  or id_time_of_day == 2:
			environment.background_mode = Environment.BG_COLOR
			environment.background_color = Color(0.9, 1, 1)
			environment.fog_light_color = Color(0.4, 0.46, 0.46)
		if id_time_of_day == 1:
			environment.background_mode = Environment.BG_COLOR
			environment.background_color = Color(0.57, 0.66, 0.71)
			environment.fog_light_color = Color(0.57, 0.66, 0.71)
		if id_time_of_day == 3:
			environment.background_mode = Environment.BG_COLOR
			environment.background_color = Color(0.15, 0.20, 0.25)
			environment.fog_light_color = Color(0.1, 0.1, 0.1)
	# слабый снегопад
	if id_weather_conditions == 5:
		rain.hide()
		snow.show()
		s_particles.speed_scale = 0.7
		s_particles.amount = 9000
	# средний снегопад
	if id_weather_conditions == 6:
		rain.hide()
		snow.show()
		s_particles.speed_scale = 0.72
		s_particles.amount = 15500
		light.light_energy = 0
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color(0.8, 0.85, 0.9)
	# сильный снегопад
	if id_weather_conditions == 7:
		rain.hide()
		snow.show()
		s_particles.speed_scale = 0.74
		s_particles.amount = 100000
		light.light_energy = 0
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color(0.8, 0.85, 0.9)

func _on_exit_pressed():
	get_tree().quit()
