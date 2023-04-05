extends CharacterBody3D


const SPEED = 12.0
const ACC = 1000000.0
const DEACC = 2
var rotateamt = 10
const RAY_LENGTH = 1000
@onready var state_machine = $MeshInstance3D/AnimationTree["parameters/playback"]


func _physics_process(delta):
	
	if Input.is_action_just_pressed("shoot"):
		var space_state = get_world_3d().direct_space_state
		var pos = get_parent_node_3d().get_node("Sprite3D").position
		var poss = Vector2(pos.x, pos.y)
		var from = get_parent_node_3d().get_node("Camera3D").project_ray_origin(poss)
		var to = from + get_parent_node_3d().get_node("Camera3D").project_ray_normal(poss) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		for object in result:
			print(object)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		
		if direction.y > 0:
			state_machine.travel("Fall", false)
		elif direction.y < 0:
			state_machine.travel("Jump2", false)
		
	else:
		state_machine.travel("idle", false)
		$MeshInstance3D.rotation_degrees = Vector3(0,0, move_toward($MeshInstance3D.rotation_degrees.z, 0, DEACC))
		
		#position.x = move_toward(position.x, 0, DEACC)
		#position.y = move_toward(position.y, 0, DEACC)
	
	move_and_slide()
