class_name Weapon
extends Node2D

## Status describing whether the gun can fire, and if not why
enum FireStatus {
	CAN_FIRE,
	STILL_FIRING,
	RELOADING,
	NO_AMMO,
}

@export var bullet_data: BulletData
@export var max_ammo: int
@export var full_auto: bool
@export var rounds_reload: bool
## Angle to either direction that a bullet may deviate
@export_range(0, 90, 0.1, "radians_as_degrees") var spread: float = 0.04
@export var bullets_per_shot: int = 1

var ammo: int
var trigger_pulled: bool = false

@onready var fire_cooldown: Timer = $FireCooldown
@onready var reload_cooldown: Timer = $ReloadCooldown
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
	ammo = max_ammo
	reload_cooldown.timeout.connect(reload_finished)

func _physics_process(_delta: float) -> void:
	if full_auto and trigger_pulled:
		fire_if_possible()
	
	if Input.is_action_just_pressed("debug1"):
		pull_trigger()
	if Input.is_action_just_released("debug1"):
		release_trigger()
	if Input.is_action_just_pressed("debug2"):
		reload()

func reload() -> void:
	# avoid reloading if we are full ammo on rounds reload
	if rounds_reload and ammo == max_ammo:
		return
	# avoid restarting timer if a reload was already underway
	if reload_cooldown.is_stopped():
		reload_cooldown.start()

func reload_finished() -> void:
	# TODO: add rounds reload functionality
	if rounds_reload:
		ammo += 1
	else: 
		ammo = max_ammo

func pull_trigger() -> void:
	trigger_pulled = true
	fire_if_possible()

func release_trigger() -> void:
	trigger_pulled = false

func fire_if_possible() -> FireStatus:
	var status: FireStatus = get_fire_status()
	if status == FireStatus.CAN_FIRE:
		fire()
	return status

## Returns whether the gun can fire
func get_fire_status() -> FireStatus:
	if not reload_cooldown.is_stopped():
		return FireStatus.RELOADING
	if not fire_cooldown.is_stopped():
		return FireStatus.STILL_FIRING
	if ammo < 1: 
		return FireStatus.NO_AMMO
	return FireStatus.CAN_FIRE

## WILL fire the weapon, no checks.  Only call once it is known if the weapon
## can/should fire
func fire() -> void:
	var angle: float = global_rotation-PI/2
	var counter: int = bullets_per_shot
	while counter > 0:
		MessageBus.bullet_spawned.emit(spawn_point.global_position, 
				Vector2.from_angle(angle + randf_range(-spread, spread)), bullet_data)
		counter -= 1
	ammo -= 1
	fire_cooldown.start()
