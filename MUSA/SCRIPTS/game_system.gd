extends Node3D

# Menyimpan ada berapa MBG yang harus dikirim
# Melakukan Manipulasi
signal add_counter

signal win_panel_activate
signal lose_panel_activate

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

signal enable_all_point


func reset_counter():
	MBG_dihantar = 0

func reset_score():
	score = 0

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F1) :
		AudioManager.play_sound("victory")
		emit_signal("win_panel_activate")
	if Input.is_key_pressed(KEY_F2):
		AudioManager.play_sound("gameover")
		emit_signal("lose_panel_activate")


func on_add_counter() -> void:
	if MBG_dihantar < targetMBG:
		MBG_dihantar += 1
		score += 20
		if MBG_dihantar >= targetMBG:
			game_finished = true
			emit_signal("win_panel_activate")
			AudioManager.play_sound("victory")
	pass
