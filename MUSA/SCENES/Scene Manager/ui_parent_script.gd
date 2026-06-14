extends CanvasLayer


@onready var level_selection_panel = $"Level Selection"
@onready var main_menu_panel = $Menu

func _show_level_selection() -> void:
	level_selection_panel.visible = true
	main_menu_panel.visible = false


func _back_to_main_menu() -> void:
	level_selection_panel.visible = false
	main_menu_panel.visible = true

func _on_play_button_pressed() -> void:
	_show_level_selection()


func _on_exit_button_pressed() -> void:
	pass


func _on_back_button_pressed() -> void:
	_back_to_main_menu()


func _on_level_1_pressed() -> void:
	SceneManager.load_level_1()


func _on_level_2_pressed() -> void:
	SceneManager.load_level_2()


func _on_level_3_pressed() -> void:
	SceneManager.load_level_3()
