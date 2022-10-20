extends Node2D

# warning-ignore-all:return_value_discarded

var logo


func _ready():
	logo = get_node("Logo")
	pass


func _on_AudioStreamPlayer2D_finished():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
