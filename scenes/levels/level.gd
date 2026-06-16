class_name Level
extends Node2D

const BULLET_TRAIL: PackedScene = preload("uid://cdiklyggpc7tl")
const BULLET: PackedScene = preload("uid://troo27efojv8")
const DEBUG_MARKER = preload("uid://ckxebogbgamgm")


@onready var characters: Node2D = $Characters
@onready var decals: Node2D = $Decals
@onready var projectiles: Node2D = $Projectiles

func _ready() -> void:
	MessageBus.bullet_spawned.connect(spawn_bullet)
	MessageBus.decal_transport_spawned.connect(spawn_decal_transport)
	MessageBus.debug_marker_spawned.connect(spawn_debug_marker)

func spawn_bullet(pos: Vector2, dir: Vector2, bullet_data: BulletData) -> void:
	var bullet: Bullet = BULLET.instantiate()
	projectiles.add_child(bullet)
	bullet.initialize(pos, dir, bullet_data)
	var bullet_trail: BulletTrail = BULLET_TRAIL.instantiate()
	projectiles.add_child(bullet_trail)
	bullet_trail.initialize(bullet)

func spawn_debug_marker(pos: Vector2) -> void:
	var marker: Sprite2D = DEBUG_MARKER.instantiate()
	marker.position = pos
	add_child(marker)

func spawn_decal_transport(pos: Vector2, rot: float, transport: DecalTransport) -> void:
	transport.initialize(pos, rot)
	decals.add_child(transport)
