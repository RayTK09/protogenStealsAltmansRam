extends Node3D

class_name weapons

@onready var weaponRange := $RayCast3D
@onready var melee := $Area3D
@onready var timer := $Timer
@onready var reloadTimer := $reloadTimer
@onready var scrollTimeout := $scrollTimer

@export var weaponName := "Pistol"
@export var currentWeapon := weapon.PISTOL
@export var ammo := 17
@export var range := 10
@export var damage := 10
@export var timeBetweenShots := 0.1
@export var reloadTime := 2

var hasWeapons := {
	meleeWeapon = true,
	pistol = true,
	rifle = false,
	smg = false,
	shotgun = false,
	rpg = false
}

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
	checkHasWeapon(changeToWeapon)
	if currentWeapon > len(weapon):
		currentWeapon = len(weapon)
	elif currentWeapon < 0:
		currentWeapon = 0
	match currentWeapon:
		weapon.MELEE:
			damage = 20
			weaponName = ""
		weapon.PISTOL:
			damage = 10
			weaponName = "Pistol"
		weapon.ASSULT_RIFLE:
			damage = 20
			weaponName = "Assult Rifle"
		weapon.SMG:
			damage = 15
			weaponName = "SMG"
		weapon.SHOTGUN:
			damage = 25
			weaponName = "Shotgun"
		weapon.ROCKET_LAUNCHER:
			damage = 120
			weaponName = "RPG"


func checkHasWeapon(changeToWeapon : int):
	if currentWeapon == 2 and hasWeapons.get("rifle") == false:
		currentWeapon += changeToWeapon
	if currentWeapon == 3 and hasWeapons.get("smg") == false:
		currentWeapon += changeToWeapon
	if currentWeapon == 4 and hasWeapons.get("shotgun") == false:
		currentWeapon += changeToWeapon
	if currentWeapon == 5 and hasWeapons.get("rpg") == false:
		currentWeapon += changeToWeapon
	if currentWeapon == 6:
		currentWeapon = weapon.PISTOL
