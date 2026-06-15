class_name Level
extends Node2D

const BULLET_TRAIL: PackedScene = preload("uid://cdiklyggpc7tl")
const BULLET: PackedScene = preload("uid://troo27efojv8")


@onready var characters: Node2D = $Characters
@onready var decals: Node2D = $Decals
@onready var projectiles: Node2D = $Projectiles

func _ready() -> void:
	MessageBus.bullet_spawned.connect(spawn_bullet)

func spawn_bullet(pos: Vector2, dir: Vector2, bullet_data: BulletData) -> void:
	var bullet: Bullet = BULLET.instantiate()
	projectiles.add_child(bullet)
	bullet.initialize(pos, dir, bullet_data)
	var bullet_trail: BulletTrail = BULLET_TRAIL.instantiate()
	projectiles.add_child(bullet_trail)
	bullet_trail.initialize(bullet)
