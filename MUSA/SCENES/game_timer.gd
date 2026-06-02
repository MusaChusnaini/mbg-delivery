extends Timer

@export var timer_label : Label

func _process(delta: float) -> void:
	if GameSystem.game_finished:
		return
	
	var total_seconds = time_left
	# Calculates and formats: MM:SS:msec
	var mins = int(total_seconds) / 60
	var secs = int(total_seconds) % 60
	var formatted_time = "%02d:%02d" % [mins, secs]

	timer_label.text = formatted_time

func _on_timeout() -> void:
	if !GameSystem.game_finished:
		print("Timeout, You Lose..")
	pass # Replace with function body.
