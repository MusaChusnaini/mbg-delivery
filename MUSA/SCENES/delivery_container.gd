class_name DeliveryContainer
extends Node3D

var delivery_points

func _ready() -> void:
	GameSystem.set_max_target(collect_children_as_target())
	GameSystem.enable_all_point.connect(enable_all_node)
	delivery_points = get_children()
	disable_all_node()
	activate_point()

func activate_point() -> void:
	var current_active_index = GameSystem.get_current_target()
	if current_active_index < collect_children_as_target():
		delivery_points[current_active_index].enable_point()

func disable_all_node() -> void:
	for point : Node3D in delivery_points:
		point.disable_point()

func enable_all_node() -> void:
	for point : Node3D in delivery_points:
		point.enable_point()
func collect_children_as_target() -> int :
	return get_child_count()
