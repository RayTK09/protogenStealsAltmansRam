extends CharacterBody3D

const SPEED := 5.0
const ACCEL := 3.0
const JUMP_VELOCITY := 6

@export var mouseSens := 0.01

@onready var camera := $Camera3D

var rotY : float
var rotX : float


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotX -= event.screen_relative.x * mouseSens
		rotY -= event.screen_relative.y * mouseSens
		transform.basis = Basis()
		camera.transform.basis = Basis()
		rotate_y(rotX)
		camera.rotate_x(rotY)
		
		camera.rotation.x = clampf(camera.rotation.x, -(PI / 2), PI / 2)
		rotY = clampf(rotY, -(PI / 2), PI / 2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(0, SPEED * direction.x, ACCEL)
		velocity.z = move_toward(0, SPEED * direction.z, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		velocity.z = move_toward(velocity.z, 0, ACCEL)

	move_and_slide()
