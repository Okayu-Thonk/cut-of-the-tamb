extends Node2D
class_name Tambourine

export var damage: int
export var attack_cooldown: int
export var projectile: PackedScene

onready var cooldown: Timer = $Cooldown
onready var audio: AudioStreamPlayer2D = $Audio


func _ready() -> void:
	cooldown.wait_time = attack_cooldown


func light_attack() -> void:
	if cooldown.is_stopped():
		if !audio.playing: 
			audio.play()
		else:
			var asp: AudioStreamPlayer2D = audio.duplicate(DUPLICATE_USE_INSTANCING)
			add_child(asp)
			asp.play()
			yield(asp, "finished")
			asp.queue_free()
		_spawn_projectile(_get_mouse_direction())
		_spawn_projectile(_get_mouse_direction() + Vector2(0.2,-0.2))
		_spawn_projectile(_get_mouse_direction() + Vector2(-0.2,0.2))
		cooldown.start()

func _spawn_projectile(target: Vector2) -> void:
	var projectile_instance: TambourineProjectile = projectile.instance()
	projectile_instance.target_coordinate = _get_mouse_direction()
	projectile_instance.direction = target
	projectile_instance.origin = global_position
	projectile_instance.damage = damage
	get_tree().current_scene.add_child(projectile_instance)
	projectile_instance.global_position = global_position
	projectile_instance.launch()

func _get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()
