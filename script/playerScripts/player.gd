extends CharacterBody3D

class_name player

const SPEED := 5.0
const ACCEL := 3.0
const JUMP_VELOCITY := 6

@onready var global : globals = get_node("/root/Gobals")
@onready var camera := $Camera3D
@onready var weapon := $Camera3D/weapons
@onready var animationPlayer := $AnimationPlayer

var health := 100
var def := 50
var rotY : float
var rotX : float
var speedMod := 1.0
var currentPlayerState : playerState = playerState.PLAY

enum playerState {
	PLAY,
	PAUSE,
	CUTSCENE
}


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and currentPlayerState == playerState.PLAY:
		rotX -= event.screen_relative.x * global.mouseSens
		rotY -= event.screen_relative.y * global.mouseSens
		transform.basis = Basis()
		camera.transform.basis = Basis()
		rotate_y(rotX)
		camera.rotate_x(rotY)
			
		camera.rotation.x = clampf(camera.rotation.x, -(PI / 2), PI / 2)
		rotY = clampf(rotY, -(PI / 2), PI / 2)
	
	if Input.is_action_just_pressed("esc") and currentPlayerState != playerState.PAUSE:
		currentPlayerState = playerState.PAUSE
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("esc") and currentPlayerState == playerState.PAUSE:
		currentPlayerState = playerState.PLAY
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("crouch"):
		animationPlayer.play("crouch")
		speedMod = 0.5
	elif Input.is_action_just_released("crouch"):
		animationPlayer.play_backwards("crouch")
		speedMod = 1


func _physics_process(delta: float) -> void:
	if currentPlayerState == playerState.PLAY:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var input_dir := Input.get_vector("left", "right", "forward", "backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = move_toward(0, (SPEED * speedMod) * direction.x, ACCEL)
			velocity.z = move_toward(0, (SPEED * speedMod) * direction.z, ACCEL)
		else:
			velocity.x = move_toward(velocity.x, 0, ACCEL)
			velocity.z = move_toward(velocity.z, 0, ACCEL)

		move_and_slide()
