extends Node3D

# HARDCODE BOSS, YANG PENTING JALAN!

const SCENE_MAIN_MENU = preload("res://MUSA/SCENES/Scene Manager/Main-Menu.tscn")
const LEVEL_1 = preload("res://AFI/SCENES/LEVEL/Level1-Salju.tscn")
const LEVEL_2 = preload("res://AFI/SCENES/LEVEL/Level2-Gurun.tscn") # Jangan lupa ganti path level 2 nanti
const LEVEL_3 = preload("res://AFI/SCENES/LEVEL/Level3-Malam.tscn") # Jangan lupa ganti path level 3 nanti
const CREDIT_SCENE = preload("res://MUSA/SCENES/Scene Manager/Credit_Scene.tscn")

@onready var root = $"."

var inst_main_menu : Node
var inst_scene_lv1 : Node
var inst_scene_lv2 : Node
var inst_scene_lv3 : Node
var inst_credit_scene : Node

func _ready() -> void:
	load_main_menu()
	pass

## Fungsi sapu jagat: hapus semua scene yang ada (kalau tidak kosong)
func _clear_all_scenes() -> void:
	if is_instance_valid(inst_main_menu):
		inst_main_menu.queue_free()
	if is_instance_valid(inst_scene_lv1):
		inst_scene_lv1.queue_free()
	if is_instance_valid(inst_scene_lv2):
		inst_scene_lv2.queue_free()
	if is_instance_valid(inst_scene_lv3):
		inst_scene_lv3.queue_free()
	if is_instance_valid(inst_credit_scene):
		inst_credit_scene.queue_free()

## --- FUNGSI LOAD SCENE ---

func load_main_menu() -> void:
	MusicPlayer.play_track(1)
	_clear_all_scenes() # Bersihkan dulu semuanya
	inst_main_menu = SCENE_MAIN_MENU.instantiate()
	root.add_child(inst_main_menu)

func load_level_1(restart_music : bool) -> void:
	GameSystem.reset_counter()
	GameSystem.reset_score()
	GameSystem.emit_signal("enable_all_point")
	if !restart_music: 
		MusicPlayer.play_track(0)
	_clear_all_scenes()
	inst_scene_lv1 = LEVEL_1.instantiate()
	root.add_child(inst_scene_lv1)

func load_level_2(restart_music : bool) -> void:
	GameSystem.reset_counter()
	GameSystem.reset_score()
	GameSystem.emit_signal("enable_all_point")
	if !restart_music: 
		MusicPlayer.skip_to_next_track()
	_clear_all_scenes()
	inst_scene_lv2 = LEVEL_2.instantiate()
	root.add_child(inst_scene_lv2)

func load_level_3(restart_music : bool) -> void:
	GameSystem.reset_counter()
	GameSystem.reset_score()
	GameSystem.emit_signal("enable_all_point")
	if !restart_music: 
		MusicPlayer.skip_to_next_track()
	_clear_all_scenes()
	inst_scene_lv3 = LEVEL_3.instantiate()
	root.add_child(inst_scene_lv3)

func load_credit_scene(restart_music : bool):
	if !restart_music: 
		MusicPlayer.skip_to_next_track()
	_clear_all_scenes()
	inst_credit_scene = CREDIT_SCENE.instantiate()
	root.add_child(inst_credit_scene)

func restart_current_scene() -> void:
	GameSystem.reset_counter()
	GameSystem.reset_score()
	GameSystem.emit_signal("enable_all_point")
	if is_instance_valid(inst_scene_lv1):
		load_level_1(true)
	elif is_instance_valid(inst_scene_lv2):
		load_level_2(true)
	elif is_instance_valid(inst_scene_lv3):
		load_level_3(true)
	elif is_instance_valid(inst_main_menu):
		load_main_menu()
	else:
		push_warning("Tidak ada scene yang aktif untuk direstart!")
