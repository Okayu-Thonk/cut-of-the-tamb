extends Node2D


func _ready():
	pass  # Replace with function body.


func _on_AudioStreamPlayer2D_finished():
	print("okayu finish")
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
