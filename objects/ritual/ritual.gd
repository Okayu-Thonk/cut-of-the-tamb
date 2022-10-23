extends Node2D
class_name Ritual

# warning-ignore-all:return_value_discarded

export var health: int = 5000 setget set_health
export var faith_per_second: int = 10

onready var health_bar: ProgressBar = $CanvasLayer/Control/VBoxContainer/ProgressBar


func _ready() -> void:
	GlobalSignal.connect("enemy_spawned", self, "_on_enemy_spawned")
	health_bar.max_value = health
	health_bar.value = health


func set_health(new_health: int) -> void:
	if new_health == 0:
		_destroyed()
		return
	health = new_health
	health_bar.value = health


func _destroyed() -> void:
	GlobalSignal.emit_signal("ritual_destroyed")


func _generate_faith() -> void:
	GlobalSignal.emit_signal("faith_generated", faith_per_second)


func _on_FaithTimer_timeout() -> void:
	_generate_faith()


func _on_enemy_spawned(type: String) -> void:
	print("enemy spawned" + type)
	GlobalSignal.emit_signal("ritual_coordinate_sent", self.global_position)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if area.get_class() == "Projectile":
		set_health(health - area.damage)
		if !area.has_method("melee"):
			area.queue_free()
