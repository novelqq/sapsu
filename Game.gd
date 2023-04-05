extends Node3D
const dolly_speed = 5
func _physics_process(delta):
	$Path3D/PathFollow3D.progress += delta* dolly_speed
