extends Node2D
class_name Tambourine

export var damage: int
export var attack_cooldown: int
export var projectile: PackedScene

onready var cooldown: Timer = $Cooldown

func _ready() -> void:
  cooldown.wait_time = attack_cooldown

func light_attack() -> void:
  if cooldown.is_stopped():
    var projectile_instance:TambourineProjectile = projectile.instance()
    projectile_instance.target_coordinate = _get_mouse_direction()
    projectile_instance.direction = _get_mouse_direction()
    projectile_instance.origin = global_position
    get_tree().current_scene.add_child(projectile_instance)
    projectile_instance.global_position = global_position
    projectile_instance.launch()
    cooldown.start()

func _get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()
