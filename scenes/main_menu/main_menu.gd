extends Node2D


func _ready():
	pass  # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://levels/level_one/level_one.tscn")
