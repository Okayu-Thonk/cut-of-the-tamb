extends Area2D
class_name TowerProjectile

export var damage: int
export var speed: int = 200
export var knockback_strength: float

onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D

var origin: Vector2
var direction = Vector2.ZERO
var ritual_coordinate: Vector2


func _process(delta: float) -> void:
	global_position += speed * direction * delta


func launch() -> void:
	var angle = ((global_position - ritual_coordinate).normalized()).angle()
	sprite.rotate(angle)
