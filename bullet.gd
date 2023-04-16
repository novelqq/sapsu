extends CharacterBody3D
const speed = 2
func _physics_process(delta):
	move_and_collide(velocity.normalized() * delta * speed)

