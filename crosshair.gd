extends Sprite3D
const mouse_sensitivity = 0.005
const controller_sensitivity = 2
var bullet = preload("res://bullet.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x * mouse_sensitivity
		position.y += -event.relative.y * mouse_sensitivity
		position.x = clampf(position.x, -100, 100)
		position.y = clampf(position.y, -50, 50)

func _process(_delta):
	var input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y, 0))
	if direction:
		position.x += direction.x * controller_sensitivity
		position.y += -direction.y * controller_sensitivity
		position.x = clampf(position.x, -8, 8)
		position.y = clampf(position.y, -8, 8)

func _physics_process(_delta):
	if Input.is_action_just_pressed("shoot"):
		print("shoot pressed")
		var space_state = get_world_3d().direct_space_state
		var pos = get_parent_node_3d().get_node("Sprite3D").position
		var poss = Vector2(pos.x, pos.y)
		var from = get_parent().get_node("Camera3D").project_ray_origin(poss)
		var to = from + get_parent().get_node("Camera3D").project_ray_normal(poss) * 100
		var instance = bullet.instantiate()
		get_parent().add_child(instance)
		instance.position = get_parent().get_node("Player").global_position
		instance.velocity = get_parent().get_node("Sprite3D").global_position - get_parent().get_node("Camera3D").global_position 
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		print(result)
		for object in result:
			print(object)
