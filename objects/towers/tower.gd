extends Node2D

export var projectile: PackedScene

var enemy_coordinate: Vector2
var enemies: Array


func _ready() -> void:
	pass


func _on_AttackInterval_timeout() -> void:
	if !enemies.empty():
		var projectile_instance = projectile.instance()
		projectile_instance.ritual_coordinate = enemies[0].global_position
		projectile_instance.direction = (enemies[0].global_position - global_position).normalized()
		projectile_instance.origin = global_position
		add_child(projectile_instance)
		projectile_instance.launch()


func _on_Range_body_entered(body: Node):
  enemies.append(body)


func _on_Range_body_exited(body: Node):
  enemies.erase(body)
