extends Control

@onready var timer_node: Timer = $Timer
@onready var timer_label: Label = $Timer/Panel/Label1/Label2

var minutes: int = 1
var seconds: int = 30


func _ready() -> void:
	print("SCRIPT UI JALAN")
	print("Timer node ketemu: ", timer_node)
	print("Label timer ketemu: ", timer_label)

	update_timer_label()

	timer_node.wait_time = 1.0
	timer_node.start()

	print("Timer dimulai dari: ", timer_label.text)


func _on_timer_timeout() -> void:
	print("TIMEOUT KEPANGGIL")

	if minutes == 0 and seconds == 0:
		timer_node.stop()
		timer_label.text = "00:00"
		print("Timer selesai")
		return

	if seconds == 0:
		minutes -= 1
		seconds = 59
	else:
		seconds -= 1

	update_timer_label()

	print("Waktu sekarang: ", timer_label.text)


func update_timer_label() -> void:
	timer_label.text = "%02d:%02d" % [minutes, seconds]
