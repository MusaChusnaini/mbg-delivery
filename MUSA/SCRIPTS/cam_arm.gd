extends SpringArm3D

var MouseSensitivity = 0.1

func _ready() -> void:
	return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	top_level = true

func _input(event: InputEvent) -> void:
	return
	if Input.is_key_pressed(KEY_Q):
		pass
	
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * MouseSensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90, -10)
		
		rotation_degrees.y -= event.relative.x * MouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y , 0, 360)
		
