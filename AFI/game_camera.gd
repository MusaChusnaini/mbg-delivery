extends Camera3D
@onready var camPos = $"../car_sedan2/Camera3D"

func _physics_process(delta: float) -> void:
	position = position.lerp(camPos.global_position, 20)
	pass
