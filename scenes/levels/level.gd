class_name Level
extends Node2D

const BULLET_TRAIL = preload("uid://cdiklyggpc7tl")

@onready var characters: Node2D = $Characters
@onready var decals: Node2D = $Decals
@onready var projectiles: Node2D = $Projectiles

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		spawn_bullet(load("res://scenes/projectiles/bullet_generic.tscn"), get_global_mouse_position(), Vector2(1,0))

func spawn_bullet(bullet_scene: PackedScene, pos: Vector2, dir: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	projectiles.add_child(bullet)
	bullet.initialize(pos, dir)
	var bullet_trail: BulletTrail = BULLET_TRAIL.instantiate()
	projectiles.add_child(bullet_trail)
	bullet_trail.bullet = bullet
