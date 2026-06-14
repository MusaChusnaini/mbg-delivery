extends Control

# Ini buat ngontrol local scene panel yang aktif


@export var win_panel : Control
@export var lose_panel : Control


func _ready() -> void:
	win_panel.visible = false
	lose_panel.visible = false
	
	GameSystem.win_panel_activate.connect(on_win_panel_activate)
	GameSystem.lose_panel_activate.connect(on_lost_panel_activate)

func on_win_panel_activate():
	win_panel.visible = true
	lose_panel.visible = false

func on_lost_panel_activate():
	win_panel.visible = false
	lose_panel.visible = true

func restart_game():
	AudioManager.play_sound("button-click")
	SceneManager.restart_current_scene()

func return_main_menu():
	SceneManager.load_main_menu()
	AudioManager.play_sound("button-click")

func _on_restart_game_button_pressed() -> void:
	AudioManager.play_sound("button-click")
	restart_game()

func next_lv2():
	AudioManager.play_sound("button-click")
	SceneManager.load_level_2(false)

func next_lv3():
	AudioManager.play_sound("button-click")
	SceneManager.load_level_3(false)

func next_credit_scene():
	AudioManager.play_sound("button-click")
	SceneManager.load_credit_scene(false)
	pass

func _on_return_menu_button_pressed() -> void:
	AudioManager.play_sound("button-click")
	return_main_menu()


func _on_next_lv_2_button_pressed() -> void:
	next_lv2()


func _on_restart_button_pressed() -> void:
	SceneManager.restart_current_scene()


func _on_next_lv_3_button_pressed() -> void:
	next_lv3()


func _on_next_credit_button_pressed() -> void:
	next_credit_scene()
