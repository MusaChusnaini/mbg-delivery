extends CanvasLayer

func _on_a_button_pressed() -> void:
	SceneManager.load_scene_b()


func _on_b_button_pressed() -> void:
	SceneManager.load_scene_a()
