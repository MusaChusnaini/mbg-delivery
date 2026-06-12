extends VehicleBody3D


@export var km_h_label : Label
var speed_kmh : int = 0
var nitro_enabled : bool = false

@export_category("Car Settings")
## max steer in radians for the front wheels- defaults to 0.45
@export var max_steer : float = 0.45
## the maximum torque that the engine will sent to the rear wheels- defaults to 300
@export var max_torque : float = 300.0
## the maximum amount of braking force applied to the wheel. Default is 1.0
@export var max_brake_force : float = 1.0
## the maximum rear wheel rpm. The actual engine torque is scaled in a linear vector to ensure the rear wheels will never go beyond this given rpm.
## The default value is 600rpm
@export var max_wheel_rpm : float = 600.0
## How quickly the wheel responds to player input- equates to seconds to reach maximum steer. Default is 2.0
@export var steer_damping = 2.0
## How sticky are the front wheels. Default is 5. 0 is frictionless._add_constant_central_force
@export var front_wheel_grip : float = 5.0
## How sticky are the rear wheel. Default is 5. Try lower value for a more drift experience
@export var rear_wheel_grip : float = 5.0
@export_category("Engine Sound Settings")
## Pitch terendah saat mobil diam (idle)
@export var min_engine_pitch : float = 0.8
## Pitch tertinggi saat RPM mencapai batas maksimal
@export var max_engine_pitch : float = 2.5

@export_category("Nitro Settings")
## Kapasitas maksimal nitro (misal: 100 poin)
@export var max_nitro_capacity : float = 100.0
## Berapa banyak nitro yang berkurang per detik saat tombol ditahan
@export var nitro_drain_rate : float = 25.0
## Pengali torsi (dorongan) saat nitro aktif (misal 1.5 = tenaga naik 150%)
@export var nitro_torque_multiplier : float = 1.8
## Pengali putaran roda maksimal agar top speed bertambah saat nitro aktif
@export var nitro_rpm_multiplier : float = 1.5
@export var nitro_regen_rate : float = 10.0
# Status nitro internal
var current_nitro : float = 0.0
var is_using_nitro : bool = false

#local member variables
var player_acceleration : float = 0.0
var player_braking : float = 0.0
var player_steer : float = 0.0
var player_input : Vector2 = Vector2.ZERO
@onready var engine : AudioStreamPlayer = $EngineSound

#an exporetd array of driving wheels so we can limit rom of each wheel when we process input
@onready var driving_wheels : Array[VehicleWheel3D] = [$WheelBackLeft,$WheelBackRight]
@onready var steering_wheels : Array[VehicleWheel3D] = [$WheelFrontLeft,$WheelFrontRight]


func _ready() -> void:
	#set wheel friction slip
	for wheel in steering_wheels:
		wheel.wheel_friction_slip = front_wheel_grip
	for wheel in driving_wheels:
		wheel.wheel_friction_slip = rear_wheel_grip
	
	# Pastikan suara mesin menyala
	if engine and not engine.playing:
		engine.play()
	current_nitro = max_nitro_capacity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_input(delta)
	#now process steering and braking
	steering = player_steer
	brake = player_braking
	
	speed_kmh = linear_velocity.length() * 3.6
	km_h_label.text = str(round(speed_kmh))
	
	var current_max_torque = max_torque
	var current_max_rpm = max_wheel_rpm
	# Cek apakah sedang ngegas, nekan tombol nitro, dan nitro masih ada
	if is_using_nitro and current_nitro > 0:
		current_nitro -= nitro_drain_rate * delta
		# Terapkan pengali (multiplier) ke tenaga dan rpm
		current_max_torque = max_torque * nitro_torque_multiplier
		current_max_rpm = max_wheel_rpm * nitro_rpm_multiplier
		
		# Jaga agar nilai tidak tembus ke minus
		if current_nitro < 0:
			current_nitro = 0.0
	else:
		if current_nitro < max_nitro_capacity:
			current_nitro += nitro_regen_rate * delta
			if current_nitro > max_nitro_capacity:
				current_nitro = max_nitro_capacity
	
	var current_avg_rpm : float = 0.0 # Untuk menghitung rata-rata RPM
	for wheel in driving_wheels:
		var wheel_rpm = abs(wheel.get_rpm())
		current_avg_rpm += wheel_rpm
		var actual_force : float = player_acceleration * ((-current_max_torque/current_max_rpm) * wheel_rpm + current_max_torque) 
		wheel.engine_force = actual_force
	
	current_avg_rpm /= driving_wheels.size()
	var rpm_ratio : float = clamp(current_avg_rpm / max_wheel_rpm, 0.0, 1.0)
	var target_pitch : float = min_engine_pitch + (rpm_ratio * (max_engine_pitch - min_engine_pitch))
	if player_acceleration != 0.0:
		target_pitch += 0.2
	if engine:
		engine.pitch_scale = lerp(engine.pitch_scale, target_pitch, 5.0 * delta)

## sets the variables player_steer, player_brake and player_acceleration based on the player input
func get_input(delta : float):
	#steer first
	player_input.x = Input.get_axis("Right","Left")
	player_steer = move_toward(player_steer, player_input.x * max_steer,steer_damping * delta)
	#now acceleration and/or braking
	player_input.y = Input.get_axis("Brake","Gas")
	
	if Input.is_action_pressed("Nitro") and player_input.y > 0.01:
		AudioManager.play_sound("whoosh-nitro-aftermath")
		is_using_nitro = true
	else:
		AudioManager.play_sound("whoosh-nitro")
		is_using_nitro = false
	
	if player_input.y > 0.01:
		#accelerating
		player_acceleration = player_input.y
		player_braking = 0.0
	elif player_input.y < -0.01:
		#we are trying to brake or reverse
		if going_forward():
			#brake
			player_braking = -player_input.y * max_brake_force
			player_acceleration = 0.0
		else:
			#reverse
			player_braking = 0.0
			player_acceleration = player_input.y
	else:
		player_acceleration = 0.0
		player_braking = 0.0


## helper function to see if we are moving forward
func going_forward() -> bool:
	var relative_speed : float = basis.z.dot(linear_velocity.normalized())
	if relative_speed > 0.01:
		return true
	else:
		return false
	
