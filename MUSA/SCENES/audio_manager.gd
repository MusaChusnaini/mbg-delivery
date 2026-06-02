extends Node
var sounds_dict : Dictionary = {}

func _ready() -> void:
	# Looping semua child node yang ada di bawah AudioManager
	for child in get_children():
		if child is AudioStreamPlayer:
			# Simpan ke dictionary dengan key huruf kecil (lowercase)
			# agar pemanggilannya tidak sensitif huruf besar/kecil
			sounds_dict[child.name.to_lower()] = child

func play_sound(sound_name: String) -> void:
	var key = sound_name.to_lower()
	
	if sounds_dict.has(key):
		sounds_dict[key].play()
	else:
		push_warning("AudioManager: Suara dengan nama '" + sound_name + "' tidak ditemukan!")

func stop_sound(sound_name: String) -> void:
	var key = sound_name.to_lower()
	if sounds_dict.has(key):
		sounds_dict[key].stop()
