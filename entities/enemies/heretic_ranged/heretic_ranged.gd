extends KinematicBody2D
class_name HereticRanged

enum State {
	MOVING,
	ATTACKING,
	IDLE,
}

export var acceleration: int = 100
export var friction: float = 0.7

onready var animation: AnimationPlayer = $Animation
onready var sprite: Sprite  = $Sprite
onready var weapon: Node2D  = $Weapon

var velocity: Vector2 = Vector2.ZERO
var ritual_coordinate: Vector2 = Vector2.ZERO
var enemy_type: String = "heretic_ranged"
var state: int = State.IDLE


func _ready():
	var _x = GlobalSignal.connect("ritual_coordinate_sent", self, "_on_coord_received")
	GlobalSignal.emit_signal("enemy_spawned", enemy_type)


func _process(delta: float) -> void:
	_move(delta)
	_sprite_handler()


func _sprite_handler():
  var ritual_direction: Vector2 = get_ritual_direction()
  if velocity.length() > 10:
    animation.play("move")
  else:
    animation.play("idle")
  _flip_character_sprite(ritual_direction)


func _move(delta: float) -> void:
	if state == State.MOVING:
		velocity = move_and_slide(velocity)
		velocity += acceleration * self.global_position.direction_to(ritual_coordinate) * delta * 60
		velocity = lerp(velocity, Vector2.ZERO, friction)


func _on_coord_received(coord: Vector2) -> void:
	ritual_coordinate = coord
	state = State.MOVING


func _flip_character_sprite(ritual_direction):
	if ritual_direction.x < 0 and sign(sprite.scale.x) != sign(ritual_direction.x):
		weapon.scale.x *= -1
		sprite.scale.x *= -1
		weapon.position.x *= -1
	elif ritual_direction.x > 0 and sign(sprite.scale.x) != sign(ritual_direction.x):
		weapon.scale.x *= -1
		sprite.scale.x *= -1
		weapon.position.x *= -1

func get_ritual_direction() -> Vector2:
	return (ritual_coordinate - global_position).normalized()
