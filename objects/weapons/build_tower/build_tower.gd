extends Node2D

export var tower: PackedScene
onready var sprite: Sprite = $Sprite
var place_color: Color


func _process(_delta):
  sprite.modulate = place_color

func light_attack(origin) -> void:
	var tower_instance = tower.instance()
	if get_tree().current_scene.has_node("YSort"):
		get_tree().current_scene.ysort.add_child(tower_instance)
	else:
		get_tree().current_scene.add_child(tower_instance)
	tower_instance.global_position = origin
