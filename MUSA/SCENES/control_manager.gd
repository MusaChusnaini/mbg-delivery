extends Control

# Ini buat ngontrol scene panel yang aktif

@onready var game_ui = $"UI_UX - CanvasLayer"
@onready var win_screen = $"Win Screen - CanvasLayer"

func enable_win_screen() -> void :
	win_screen.visible = true
	pass
