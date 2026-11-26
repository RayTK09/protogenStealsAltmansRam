extends Node3D

class_name weapons

@onready var weaponRange := $RayCast3D
@onready var melee := $Area3D

@export var weaponName : String
@export var type := weaponType.PISTOL
@export var ammo := 17
@export var range := 10
@export var damage := 10
@export var timeBetweenShots := 1.0

enum weaponType {
	MELEE,
	PISTOL,
	ASSULT_RIFLE,
	SMG,
	SHOTGUN,
	SNIPER,
	ROCKET_LAUNCHER
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weaponRange.target_position = Vector3(0, 0, -range)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		if weaponRange.get_collider() == null:
			pass
		else:
			weaponRange.get_collider().health -= damage
			print(weaponRange.get_collider().health)
	
