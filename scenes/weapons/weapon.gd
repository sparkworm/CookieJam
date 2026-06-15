class_name Weapon
extends Node2D

## Status describing whether the gun can fire, and if not why
enum FireStatus {
	CAN_FIRE,
	STILL_FIRING,
	NO_AMMO,
}

@export var bullet_data: BulletData
@export var max_ammo: int
@export var full_auto: bool

var ammo: int
var trigger_pulled: bool = false

@onready var fire_cooldown: Timer = $FireCooldown
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
	ammo = max_ammo

func _process(_delta: float) -> void:
	if full_auto and trigger_pulled:
		fire_if_possible()
	
	if Input.is_action_just_pressed("debug1"):
		pull_trigger()
	if Input.is_action_just_released("debug1"):
		release_trigger()

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

## returns whether the gun can fire
func get_fire_status() -> FireStatus:
	if not fire_cooldown.is_stopped():
		return FireStatus.STILL_FIRING
	if ammo < 1: 
		return FireStatus.NO_AMMO
	return FireStatus.CAN_FIRE

## WILL fire the weapon, no checks.  Only call once it is known if the weapon
## can/should fire
func fire() -> void:
	MessageBus.bullet_spawned.emit(spawn_point.global_position, 
			Vector2.from_angle(global_rotation-PI/2), bullet_data)
	ammo -= 1
	fire_cooldown.start()
