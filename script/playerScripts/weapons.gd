extends Node3D

class_name weapons

@onready var weaponRange := $RayCast3D
@onready var melee := $Area3D

@export var weaponName : String
@export var type := weaponType.PISTOL
@export var ammo := 17
@export var range := 10
@export var damage := 10

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
