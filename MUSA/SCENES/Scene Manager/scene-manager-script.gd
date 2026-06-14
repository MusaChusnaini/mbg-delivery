extends Node3D

# HARDCODE BOSS, YANG PENTING JALAN!

const SCENE_MAIN_MENU = preload("res://MUSA/SCENES/Scene Manager/Main-Menu.tscn")
const LEVEL_1 = preload("res://MUSA/SCENES/Scene Manager/PrototypeLevel.tscn")
const LEVEL_2 = preload("res://MUSA/SCENES/Scene Manager/PrototypeLevel.tscn") # Jangan lupa ganti path level 2 nanti
const LEVEL_3 = preload("res://MUSA/SCENES/Scene Manager/PrototypeLevel.tscn") # Jangan lupa ganti path level 3 nanti

@onready var root = $"."

var inst_main_menu : Node
var inst_scene_lv1 : Node
var inst_scene_lv2 : Node
var inst_scene_lv3 : Node

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

## --- FUNGSI LOAD SCENE ---

func load_main_menu() -> void:
	MusicPlayer.play_track(1)
	_clear_all_scenes() # Bersihkan dulu semuanya
	inst_main_menu = SCENE_MAIN_MENU.instantiate()
	root.add_child(inst_main_menu)

func load_level_1() -> void:
	MusicPlayer.play_track(0)
	_clear_all_scenes()
	inst_scene_lv1 = LEVEL_1.instantiate()
	root.add_child(inst_scene_lv1)

func load_level_2() -> void:
	MusicPlayer.skip_to_next_track()
	_clear_all_scenes()
	inst_scene_lv2 = LEVEL_2.instantiate()
	root.add_child(inst_scene_lv2)

func load_level_3() -> void:
	MusicPlayer.skip_to_next_track()
	_clear_all_scenes()
	inst_scene_lv3 = LEVEL_3.instantiate()
	root.add_child(inst_scene_lv3)
