extends Sprite3D
const mouse_sensitivity = 0.005
const controller_sensitivity = 2
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x * mouse_sensitivity
		position.y += -event.relative.y * mouse_sensitivity
		position.x = clampf(position.x, -100, 100)
		position.y = clampf(position.y, -50, 50)

func _process(delta):
	var input_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y, 0))
	if direction:
		position.x += direction.x * controller_sensitivity
		position.y += -direction.y * controller_sensitivity
		position.x = clampf(position.x, -8, 8)
		position.y = clampf(position.y, -8, 8)
