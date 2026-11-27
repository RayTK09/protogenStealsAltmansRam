extends CharacterBody3D

const SPEED := 2.0
const ACCEL := 3.0

@onready var nav := $NavigationAgent3D

@export var player : player

var health := 100

enum enemyState {
	IDLE,
	PATROLING,
	CAUTION,
	ATTACKING
}


func _ready() -> void:
	var getParentNode = get_parent()
	player = getParentNode.get_child(0)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	look_at(player.position)
	
	#I have used this tutorial to figure out how to move the enemy to the players position
	#https://www.youtube.com/watch?v=XvRY-g27OQk
	var direction = (nav.get_next_path_position() - global_position).normalized()
	if !nav.is_navigation_finished():
		velocity.x = move_toward(0, SPEED * direction.x, ACCEL)
		velocity.z = move_toward(0, SPEED * direction.z, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		velocity.z = move_toward(velocity.z, 0, ACCEL)
	
	move_and_slide()
	
	if health <= 0:
		queue_free()
	
	#print(nav.get_next_path_position())
	nav.target_position = player.position
