extends Node
var notif: PackedScene = preload("res://scenes/notification/notification.tscn")


func send_notif(label: String, origin_coord: Vector2) -> void:
	var notif_instance = notif.instance()
	notif_instance.get_node("Container/Label").text = label
	notif_instance.get_node("Container").global_position = origin_coord
	get_tree().current_scene.add_child(notif_instance)
