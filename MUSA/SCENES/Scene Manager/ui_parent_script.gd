extends CanvasLayer


@onready var level_selection_panel = $"Level Selection"
@onready var main_menu_panel = $Menu

func _show_level_selection() -> void:
	AudioManager.play_sound("button-click")
	level_selection_panel.visible = true
	main_menu_panel.visible = false


func _back_to_main_menu() -> void:
	AudioManager.play_sound("button-click")
	SceneManager.load_main_menu()

func _on_play_button_pressed() -> void:
	AudioManager.play_sound("button-click")
	_show_level_selection()


func _on_exit_button_pressed() -> void:
	AudioManager.play_sound("button-click")
	get_tree().quit()
	pass


func _on_back_button_pressed() -> void:
	AudioManager.play_sound("button-click")
	_back_to_main_menu()


func _on_level_1_pressed() -> void:
	AudioManager.play_sound("button-click")
	SceneManager.load_level_1(false)


func _on_level_2_pressed() -> void:
	AudioManager.play_sound("button-click")
	SceneManager.load_level_2(false)


func _on_level_3_pressed() -> void:
	AudioManager.play_sound("button-click")
	SceneManager.load_level_3(false)
