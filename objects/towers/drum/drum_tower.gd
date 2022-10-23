extends Tower

func _on_AttackInterval_timeout() -> void:
	if !enemies.empty():
		_spawn_projectile()
		

func _spawn_projectile() -> void:
		for e in enemies:
			var projectile_instance = projectile.instance()
			projectile_instance.ritual_coordinate = e.global_position
			projectile_instance.direction = (e.global_position - global_position).normalized()
			projectile_instance.origin = global_position
			add_child(projectile_instance)
			projectile_instance.launch()	
