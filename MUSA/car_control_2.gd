extends VehicleBody3D

var max_rpm = 4500
var max_torque = 1500
var turn_speed = 3
var turn_amount = 0.17
@onready var km_h_label : Label = $"../CanvasLayer/Control/KM_H"
var speed_kmh = 0.0
@onready var cam_pivot = $CameraPivot


func _physics_process(delta: float) -> void:
	# $CamArm.position = position
	
	speed_kmh = linear_velocity.length() * 3.6
	km_h_label.text = str(round(speed_kmh), " km/h")
	
	
	cam_pivot.global_position = cam_pivot.global_position.lerp(global_position, delta * 20)
	cam_pivot.transform = cam_pivot.transform.interpolate_with(transform, delta * 5.0)
	
	var dir = Input.get_action_strength("Gas") - Input.get_action_strength("Brake")
	var steering_dir = Input.get_action_strength("Left") - Input.get_action_strength("Right")
	
	var rpm_left = abs($RearLeft.get_rpm())
	var rpm_right = abs($RearRight.get_rpm())
	var rpm = (rpm_left + rpm_right) / 2.0
	
	var torque = dir * max_torque * (1.0 - rpm / max_rpm)
	
	engine_force = torque
	steering = lerp(steering, steering_dir * turn_amount, turn_speed * delta)
	
	if dir == 0:
		brake = 2
