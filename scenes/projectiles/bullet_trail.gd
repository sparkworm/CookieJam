## Draws a trail for a specified bullet.  I've used a very similar approach before, though I'm 
## realizing now that this is not super efficient, since we are treating what is presumably just an 
## array like a deque, which it likely isn't optimized for.  The alternative (that achieves the same
## look) would be much harder to implement, so I will just eat the performance cost.
class_name BulletTrail
extends Line2D

@export var max_points: int = 5

var bullet: Bullet
## If has_collided is true, we can expect the bullet to be null on the next frame.
## the whole point of this is to shrink the tail instead of disappearing instantly
var has_collided: bool = false

func initialize(target: Bullet) -> void:
	bullet = target
	bullet.bullet_collided.connect(handle_collision)

func _process(_delta: float) -> void:
	if not has_collided:
		# if the bullet is null, that means it has been despawned (not collided)
		# in this case we may as well despawn the trail instantly
		if bullet != null:
			follow_bullet()
		else:
			#push_warning("Warning in BulletTrail: bullet is null")
			queue_free()
	else:
		# delete if we have no more points
		if points.size() == 0:
			queue_free()
		# removed oldest point to create effect of tail shrinking
		remove_point(0)

func follow_bullet() -> void:
	# something something time complexity
	add_point(bullet.global_position)
	if (points.size() > max_points):
		remove_point(0)

func handle_collision(_collider: Object) -> void:
	has_collided = true
	# ASSUME: since we are in here, there must be a bullet
	follow_bullet()
	
