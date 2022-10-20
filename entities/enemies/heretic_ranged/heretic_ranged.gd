extends KinematicBody2D
class_name HereticRanged

# warning-ignore-all:return_value_discarded

enum State {
	MOVING,
	ATTACKING,
	IDLE,
}

export var friction: float = 0.7
export var acceleration: int = 100
export var projectile: PackedScene
export var hp: int = 10 setget set_health

onready var sprite: Sprite = $Sprite
onready var weapon: Node2D = $Weapon
onready var animation: AnimationPlayer = $Animation

var state: int = State.IDLE
var velocity: Vector2 = Vector2.ZERO
var enemy_type: String = "heretic_ranged"
var ritual_coordinate: Vector2 = Vector2.ZERO


func _ready() -> void:
	GlobalSignal.connect("ritual_coordinate_sent", self, "_on_coord_received")
	GlobalSignal.emit_signal("enemy_spawned", enemy_type)


func _process(delta: float) -> void:
	_move(delta)
	_sprite_handler()


############
# Movement #
############


func _move(delta: float) -> void:
	if state == State.MOVING:
		velocity = move_and_slide(velocity)
		velocity += acceleration * self.global_position.direction_to(ritual_coordinate) * delta * 60
	if (ritual_coordinate - global_position).length() < randi() % 150:
		state = State.ATTACKING
	velocity = lerp(velocity, Vector2.ZERO, friction)


##########
# Combat #
##########


func set_health(new_hp: int) -> void:
	hp = new_hp
	if hp <= 0:
		queue_free()


func _on_AttackTimer_timeout() -> void:
	if state == State.ATTACKING:
		var projectile_instance = projectile.instance()
		projectile_instance.ritual_coordinate = ritual_coordinate
		projectile_instance.direction = _get_ritual_direction()
		projectile_instance.origin = global_position
		add_child(projectile_instance)
		projectile_instance.launch()


func _on_Area2D_area_entered(area: Area2D) -> void:
  if(area.get_class()!="TowerRange"):
    set_health(hp - 3)
    area.queue_free()


##########
# Sprite #
##########


func _sprite_handler() -> void:
	var ritual_direction: Vector2 = _get_ritual_direction()
	_animation_handler()
	_flip_character_sprite(ritual_direction)


func _flip_character_sprite(ritual_direction: Vector2) -> void:
	if ritual_direction.x < 0 and sign(sprite.scale.x) != sign(ritual_direction.x):
		weapon.scale.x *= -1
		sprite.scale.x *= -1
	elif ritual_direction.x > 0 and sign(sprite.scale.x) != sign(ritual_direction.x):
		weapon.scale.x *= -1
		sprite.scale.x *= -1
	if ritual_direction.x > 0:
		weapon.position.x = 11
	else:
		weapon.position.x = -11


func _animation_handler() -> void:
	if velocity.length() > 20:
		animation.play("move")
	else:
		animation.play("idle")


#########
# Utils #
#########


func _on_coord_received(coord: Vector2) -> void:
	ritual_coordinate = coord
	state = State.MOVING


func _get_ritual_direction() -> Vector2:
	return (ritual_coordinate - global_position).normalized()
