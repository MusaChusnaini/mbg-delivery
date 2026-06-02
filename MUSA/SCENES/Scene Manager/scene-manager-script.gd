extends Node3D

# HARDCODE BOsS, NGGA NYAMPE WAKTUNYA BJIR

# Nanti ini diubah ke scene sesuai yang ada di game.
const SCENE_A = preload("res://MUSA/SCENES/Scene Manager/scene_a.tscn")
const SCENE_B = preload("res://MUSA/SCENES/Scene Manager/scene_b.tscn")
@onready var root = $"."

var inst_scene_a : Node
var inst_scene_b : Node

func _ready() -> void:
	# load_scene_a()
	pass

func load_scene_a() -> void:
	inst_scene_a = SCENE_A.instantiate()
	root.add_child(inst_scene_a)
	
	if inst_scene_b != null:
		inst_scene_b.queue_free()


func load_scene_b() -> void:
	inst_scene_b = SCENE_B.instantiate()
	root.add_child(inst_scene_b)
	
	if inst_scene_a != null:
		inst_scene_a.queue_free()
