class_name Bullet
extends RayCast2D

signal bullet_collided(collider: Object)

var damage: int

var velocity: Vector2
var last_pos: Vector2

@onready var despawn_timer: Timer = $DespawnTimer

## Initialize the bullet with the provided GLOBAL position and direction
func initialize(pos: Vector2, dir: Vector2, data: BulletData) -> void:
	damage = data.damage
	velocity = dir * data.speed
	global_position = pos
	# set time until the bullet despawns
	despawn_timer.wait_time = data.lifetime
	despawn_timer.timeout.connect(despawn)
	despawn_timer.start()

func _physics_process(delta: float) -> void:
	var displacement: Vector2 = velocity * delta
	position += displacement
	target_position = -displacement
	if is_colliding():
		handle_collision()

## TODO: implement damaging
func handle_collision() -> void:
	# TODO: this doesn't seem to be working at stopping the bullets from visually penetrating, fix
	position = get_collision_point()
	print(position)
	var collider: Object = get_collider()
	if collider.has_method("take_hit"):
		collider.take_hit(damage)
	bullet_collided.emit(collider)
	despawn()

## Potentially handle any odd behavior with despawning
func despawn() -> void:
	queue_free()
