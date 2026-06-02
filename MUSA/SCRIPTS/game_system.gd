extends Node3D

# Menyimpan ada berapa MBG yang harus dikirim
# Melakukan Manipulasi
signal add_counter


func _ready() -> void:
	add_counter.connect(on_add_counter)

var targetMBG : int
var score : int = 0
var MBG_dihantar : int = 0
var game_finished = false


func get_current_target() -> int:
	return MBG_dihantar

func get_score() -> int:
	return score

func get_max_target() -> int:
	return targetMBG

func set_max_target(target):
	targetMBG = target

func on_add_counter() -> void:
	if MBG_dihantar < targetMBG:
		MBG_dihantar += 1
		score += 20
		if MBG_dihantar >= targetMBG:
			game_finished = true
			print("Win !")
	pass
