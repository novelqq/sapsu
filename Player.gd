extends CharacterBody3D


const SPEED = 12.0
const ACC = 1000000.0
const DEACC = 2
var rotateamt = 10
const RAY_LENGTH = 1000
@onready var state_machine = $MeshInstance3D/AnimationTree["parameters/playback"]
var moving = false

func _physics_process(delta):
	


	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y, 0))
	if direction:
		transform.origin.x += SPEED * direction.x * delta
		transform.origin.y += SPEED * -direction.y * delta
		$MeshInstance3D.rotation_degrees.z = move_toward(rotation_degrees.z, -direction.x*60, rotateamt)
		$MeshInstance3D.rotation_degrees.x = move_toward(rotation_degrees.x, -direction.y*500, rotateamt)
		var r = $MeshInstance3D.rotation_degrees
		r.z = clampf(r.z, -30, 30)
		$MeshInstance3D.rotation_degrees = r
		
		if not moving:
			if direction.y > 0:
				state_machine.travel("down")
			elif direction.y < 0:
				state_machine.travel("up")
			moving = true
		
	else:
		if moving:
			state_machine.travel("idle")
			moving = false
		$MeshInstance3D.rotation_degrees = Vector3(0,0, move_toward($MeshInstance3D.rotation_degrees.z, 0, DEACC))


		
		#position.x = move_toward(position.x, 0, DEACC)
		#position.y = move_toward(position.y, 0, DEACC)
	
	#move_and_slide()
