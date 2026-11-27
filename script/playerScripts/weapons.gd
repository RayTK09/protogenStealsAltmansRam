extends Node3D

class_name weapons

@onready var weaponRange := $RayCast3D
@onready var melee := $Area3D
@onready var timer := $Timer

@export var currentWeapon := weapon.PISTOL
@export var ammo := 17
@export var range := 10
@export var damage := 10
@export var timeBetweenShots := 0.1

enum weapon {
	MELEE,
	PISTOL,
	ASSULT_RIFLE,
	SMG,
	SHOTGUN,
	ROCKET_LAUNCHER
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weaponRange.target_position = Vector3(0, 0, -range)
	timer.wait_time = timeBetweenShots


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire") and timer.is_stopped():
		if weaponRange.get_collider() == null:
			pass
		else:
			weaponRange.get_collider().health -= damage
			print(weaponRange.get_collider().health)
			timer.start()
	
	if Input.is_action_just_pressed("changeWeaponNext") and $scrollTimer.is_stopped():
		changeWeapon(1)
		$scrollTimer.start()
	elif Input.is_action_just_pressed("changeWeaponPrevious") and $scrollTimer.is_stopped():
		changeWeapon(-1)
		$scrollTimer.start()


func _process(delta: float) -> void:
	if Input.is_action_pressed("fire") and timer.is_stopped():
		if weaponRange.get_collider() == null:
			pass
		else:
			if currentWeapon == weapon.ASSULT_RIFLE or currentWeapon == weapon.SMG:
				weaponRange.get_collider().health -= damage
				print(weaponRange.get_collider().health)
				timer.start()


func changeWeapon(changeToWeapon : int):
	currentWeapon += changeToWeapon
	if currentWeapon > len(weapon):
		currentWeapon = len(weapon)
	elif currentWeapon < 0:
		currentWeapon = 0
	match currentWeapon:
		weapon.MELEE:
			damage = 20
		weapon.PISTOL:
			damage = 10
		weapon.ASSULT_RIFLE:
			damage = 20
		weapon.SMG:
			damage = 15
		weapon.SHOTGUN:
			damage = 25
		weapon.ROCKET_LAUNCHER:
			damage = 120
	print(currentWeapon)
