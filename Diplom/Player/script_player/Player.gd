extends CharacterBody3D

# Устанавливаем константы для скорости и высоты прыжка
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Получаем значение гравитации из настроек проекта для синхронизации с узлами RigidBody.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Задаем чувствительность мыши для вращения камеры
var mouse_sense = 0.1

# Получаем ссылки на узлы Head и Camera3D через аннотации
@onready var head = $Head
@onready var camera = $Head/Camera3D

func _input(event):
	# Обрабатываем входные события от мыши для вращения камеры
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		# Ограничиваем угол наклона головы, чтобы избежать переворота
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	# Добавляем гравитацию, если персонаж не находится на полу
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Обрабатываем прыжок при нажатии кнопки "ui_accept" и нахождении на полу
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Получаем направление движения и обрабатываем передвижение/замедление
	# Важно заменить UI-действия на пользовательские для лучшей практики
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	# Применяем движение и скольжение
	move_and_slide()
