extends Node3D

var reached : bool = false
var gfx : Node3D
@export var labelTarget : Label
@export var labelScore : Label

var delivery_container : DeliveryContainer

func _ready() -> void:
	delivery_container = get_parent()
	update_target_label()

func enable_point()-> void:
	visible = true
	set_process(true)

func disable_point() -> void:
	visible = false
	set_process(false)

func update_target_label():
	labelTarget.text = str(GameSystem.get_current_target()) + " / " + str(delivery_container.collect_children_as_target())

func update_score_label():
	labelScore.text = str(GameSystem.get_score())

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and reached == false and !GameSystem.game_finished:
		AudioManager.play_sound("checkpoint")
		reached = true
		GameSystem.emit_signal("add_counter")
		update_target_label()
		update_score_label()
		delivery_container.activate_point()
		disable_point()
