extends Node3D

@export_category("Follow Camera Settings")
# Must be a vehicle body
@export var follow_target : Node3D
@export_range(0.0,10.0) var camera_height : float = 2.0
@export_range(1.0,20.0) var camera_distance : float = 5.0
@export_range(0.0,10.0) var rotation_damping = 1.0


@export_category("Camera FOV Settings")
## FOV normal saat berkendara
@export var normal_fov : float = 75.0
## FOV saat nitro aktif (layar seolah ditarik ke belakang)
@export var nitro_fov : float = 95.0
## Seberapa cepat transisi perubahan FOV
@export var fov_change_speed : float = 5.0
@onready var camera : Camera3D = $Pivot/SpringArm3D/Camera3D
@export var shake_intensity : float = 0.05

#locals
@onready var pivot : Node3D = $Pivot
@onready var springarm : SpringArm3D = $Pivot/SpringArm3D

func _ready() -> void:
	pivot.position.y = camera_height
	springarm.spring_length = camera_distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not follow_target:
		return
	
	global_position = follow_target.global_position
	var target_horizontal_direction = follow_target.global_basis.z.slide(Vector3.UP).normalized()
	if target_horizontal_direction.length_squared() > 0.001:
		global_position = follow_target.global_position
		var desired_basis = Basis.looking_at(-target_horizontal_direction)
		global_basis = global_basis.slerp(desired_basis,rotation_damping*delta)
	
	if camera:
		var target_fov = normal_fov
		var is_shaking = false
		if "is_using_nitro" in follow_target and "current_nitro" in follow_target:
			if follow_target.is_using_nitro and follow_target.current_nitro > 0:
				target_fov = nitro_fov
				is_shaking = true
		# Transisi halus menuju target FOV
		camera.fov = lerp(camera.fov, target_fov, fov_change_speed * delta)
		if is_shaking:
			camera.h_offset = randf_range(-shake_intensity, shake_intensity)
			camera.v_offset = randf_range(-shake_intensity, shake_intensity)
		else:
			camera.h_offset = lerp(camera.h_offset, 0.0, 15.0 * delta)
			camera.v_offset = lerp(camera.v_offset, 0.0, 15.0 * delta)
