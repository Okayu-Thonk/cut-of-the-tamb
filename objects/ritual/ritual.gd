extends Node2D

export var health: int = 10000 setget set_health
export var faith_per_second: int = 10

onready var health_bar = $CanvasLayer/Control/VBoxContainer/ProgressBar


func _ready():
	var _x = GlobalSignal.connect("enemy_spawned", self, "_on_enemy_spawned")
	health_bar.value = health


func set_health(new_health: int) -> void:
	if new_health == 0:
		destroyed()
		return
	health = new_health
	health_bar.value = health


func destroyed() -> void:
	GlobalSignal.emit_signal("ritual_destroyed")


func generate_faith() -> void:
	GlobalSignal.emit_signal("faith_generated", faith_per_second)


func _on_FaithTimer_timeout():
	generate_faith()


func _on_enemy_spawned(type: String):
	print("enemy spawned" + type)
	GlobalSignal.emit_signal("ritual_coordinate_sent", self.global_position)


func _on_Hurtbox_area_entered(area:Area2D):
  set_health(health-10)


